//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 22.06.2025.
//

import Foundation

final class ProfileImageService {
    private let decoder = JSONDecoder()
    private let storage = OAuth2TokenStorage()
    private var task: URLSessionTask?
    private var isProcessing = false
    private(set) var userResult: UserResult?
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private init() {}
    
    private func makeOAuthTokenRequest(accessToken: String, username: String) -> URLRequest {
        let baseURL = URL(string: "https://api.unsplash.com")
        let url = URL(
            string: "/users/\(username)",
            relativeTo: baseURL
        )!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
     }
    
    func fetchAvatarURL(username: String, completion: @escaping (Result<UserResult, Error>) -> Void) {
        if isProcessing {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        guard let token = storage.token else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        
        let url = makeOAuthTokenRequest(accessToken: token, username: username)
        
        let task = URLSession.shared.objectTask(request: url) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let body):
                guard let self else { return }
                self.userResult = body
                completion(.success(body))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL" : body.profileImage.small])
            case .failure(let error):
                print("[fetchAvatarURL]: \(error.localizedDescription)")
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
}
