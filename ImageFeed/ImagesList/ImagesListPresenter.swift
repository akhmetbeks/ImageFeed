//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 01.08.2025.
//

import Foundation
import UIKit

public protocol ImagesListPresenterProtocol {
    func viewDidLoad()
    func performBatchUpdates()
    func fetchPhotos()
    func willFetchPhotos(at indexPath: IndexPath)
    func numberOfPhotos() -> Int
    func imageURL(for indexPath: IndexPath) -> String?
    func toggleLike(at indexPath: IndexPath)
    func cellHeight(for indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat
    func configCell(with indexPath: IndexPath) -> PhotoCell?
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    weak var view: ImagesListViewControllerProtocol?
    
    func viewDidLoad() {
        fetchPhotos()
        
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.performBatchUpdates()
            }
    }
    
    func performBatchUpdates() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { i in IndexPath(row: i, section: 0) }
            view?.performBatchUpdates(indexPaths)
       }
    }
    
    func fetchPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func willFetchPhotos(at indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            fetchPhotos()
        }
    }
    
    func numberOfPhotos() -> Int {
        photos.count
    }
    
    func imageURL(for indexPath: IndexPath) -> String? {
        photos[indexPath.row].largeImageURL
    }
    
    func toggleLike(at indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let isLiked = !photo.isLiked
        
        view?.showLoading(true)
        
        imagesListService.changeLike(id: photo.id, isLike: isLiked) { [weak self] result in
            guard let self else { return }
            
            if case .success = result {
                self.photos = self.imagesListService.photos
            }
            
            self.view?.showLoading(false)
        }
    }
    
    func cellHeight(for indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        let size = photos[indexPath.row].size
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let imageWidth = size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func configCell(with indexPath: IndexPath) -> PhotoCell? {
        let photo = photos[indexPath.row]
        
        guard let createdAt = photo.createdAt else {
            return nil
        }
        
        let date = dateFormatter.string(from: createdAt)
        
        return PhotoCell(
            date: date,
            image: photo.thumbImageURL,
            isLiked: photo.isLiked)
    }
}
