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

public protocol ImagesListViewControllerProtocol: AnyObject {
    func performBatchUpdates(_ indexPaths: [IndexPath])
    func showLoading(_ isLoading: Bool)
    func updateLike(at indexPath: IndexPath, isLiked: Bool)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
        
    var presenter: ImagesListPresenterProtocol?
    let progress = UIBlockingProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)

        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let destination = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath,
                let url = presenter?.imageURL(for: indexPath)
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            destination.fullImageUrl = url
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func performBatchUpdates(_ indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func updateLike(at indexPath: IndexPath, isLiked: Bool) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        let image = UIImage(resource: isLiked ? .active : .noActive)
        cell.buttonCell.setImage(image, for: .normal)
    }
    
    func showLoading(_ isLoading: Bool) {
        if isLoading {
            progress.show()
        } else {
            progress.dismiss()
        }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        presenter?.toggleLike(at: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.cellHeight(for: indexPath, tableViewWidth: tableView.bounds.width) ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willFetchPhotos(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfPhotos() ?? 0
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
        guard let photo = presenter?.configCell(with: indexPath) else {
            return
        }
        
        let image = UIImage(resource: .stub)
        
        cell.labelViewCell.text = photo.date
        
        cell.labelViewCell.textColor = .white
        cell.labelViewCell.font = .systemFont(ofSize: 13, weight: .regular)
        
        guard let url = URL(string: photo.image) else { return }
        
        cell.imageViewCell.kf.indicatorType = .activity
        cell.imageViewCell.kf.setImage(with: url, placeholder: image)
        
        cell.buttonCell.setImage(UIImage(resource: photo.isLiked ? .active : .noActive), for: .normal)
        cell.buttonCell.setTitle(nil, for: .normal)
    }
}
