//
//  ViewController.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 15.05.2025.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    private let imagesListService = ImagesListService.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photos: [Photo] = []
    
    weak var delegate: ImagesListCellDelegate?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListService.fetchPhotosNextPage()
        
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.performBatchUpdates()
            }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let destination = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            destination.fullImageUrl = self.photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func performBatchUpdates() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
           tableView.performBatchUpdates {
               let indexPaths = (oldCount..<newCount).map { i in IndexPath(row: i, section: 0) }
               tableView.insertRows(at: indexPaths, with: .automatic)
           }
       }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func setIsLiked(_ cell: ImagesListCell, isLiked: Bool) {
        cell.buttonCell.setImage(UIImage(resource: isLiked ? .active : .noActive), for: .normal)
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let photo = photos[indexPath.row]
        let isLiked = !photo.isLiked
        
        let progress = UIBlockingProgressHUD()
        progress.show()
        
        imagesListService.changeLike(id: photo.id, isLike: isLiked) { result in
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                self.setIsLiked(cell, isLiked: isLiked)
                progress.dismiss()
            case .failure:
                progress.dismiss()
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = photos[indexPath.row].size
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        return imageListCell
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if let date = self.photos[indexPath.row].createdAt {
            cell.labelViewCell.text = dateFormatter.string(from: date)
        }
        
        cell.labelViewCell.textColor = .white
        cell.labelViewCell.font = .systemFont(ofSize: 13, weight: .regular)
        
        guard let image = UIImage(named: "Stub"),
              let url = URL(string: photos[indexPath.row].thumbImageURL) else { return }

        cell.imageViewCell.kf.indicatorType = .activity
        cell.imageViewCell.kf.setImage(with: url, placeholder: image)
        
        let buttonImageName = self.photos[indexPath.row].isLiked ? "Active" : "No Active"
        cell.buttonCell.setImage(UIImage(named: buttonImageName), for: .normal)
        cell.buttonCell.setTitle(nil, for: .normal)
    }
}
