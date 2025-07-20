//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 13.07.2025.
//

import Foundation

final class ImagesListService {
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 0
    private var isProcessing = false
    private var task: URLSessionTask?
    private let decoder = JSONDecoder()
    private let storage = OAuth2TokenStorage.shared
    private let baseURL = URL(string: "https://api.unsplash.com")
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    
    private static let dateFormatter: ISO8601DateFormatter = {
       ISO8601DateFormatter()
    }()
    
    func cleanPhotos() {
        photos = []
    }
    
    func fetchPhotosNextPage() {
        guard !isProcessing else { return }
        
        task?.cancel()
        
        guard let token = storage.token else {
            return
        }
        
        lastLoadedPage += 1
        guard let url = makeRequest(accessToken: token, url: "/photos?page=\(lastLoadedPage)", httpMethod: .GET) else {
            return
        }
        
        let task = URLSession.shared.objectTask(request: url) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let items):
                    let newPhotos = items.map { i in
                        let date = ImagesListService.dateFormatter.date(from: i.createdAt ?? "")
                        
                        return Photo(
                            id: i.id,
                            size: CGSize(width: i.width, height: i.height),
                            createdAt: date,
                            welcomeDescription: i.description,
                            thumbImageURL: i.urls.thumb,
                            largeImageURL: i.urls.full,
                            isLiked: i.likedByUser)
                    }
                    
                    self?.photos.append(contentsOf: newPhotos)
                    
                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self)
            case .failure(let error):
                print("[fetchPhotosNextPage]: \(error.localizedDescription)")
            }
            
            guard let self else { return }
            self.task = nil
            self.isProcessing = false
        }
        
        self.task = task
        self.isProcessing = true
        task.resume()
    }
    
    func changeLike(id: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        if isProcessing { return }
        
        task?.cancel()
        
        guard let token = storage.token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        guard let url = makeRequest(accessToken: token, url: "/photos/\(id)/like", httpMethod: isLike ? .POST : .DELETE) else {
            return 
        }
        
        let task = URLSession.shared.objectTask(request: url) { [weak self] (result: Result<Empty, Error>) in
            switch result {
            case .success(_):
                    guard let self else { return }
                    if let index = self.photos.firstIndex(where: { $0.id == id }) {
                        let photo = self.photos[index]
                        
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: photo.isLiked)
                        
                        self.photos[index] = newPhoto
                    }
                completion(.success(()))
            case .failure(let error):
                print("[changeLike]: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            guard let self else { return }
            self.task = nil
            self.isProcessing = false
        }
        
        self.task = task
        self.isProcessing = true
        task.resume()
    }
    
    private func makeRequest(accessToken: String, url: String, httpMethod: HTTPMethod) -> URLRequest? {
        guard let url = URL(string: url, relativeTo: baseURL) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}
