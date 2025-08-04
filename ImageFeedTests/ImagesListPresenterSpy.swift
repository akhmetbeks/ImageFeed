import ImageFeed
import UIKit
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    
    var didCallViewDidLoad = false
    var didCallToggleLike = false
    var didCallImageURL = false

    func viewDidLoad() {
        didCallViewDidLoad = true
    }

    func performBatchUpdates() {}
    func fetchPhotos() {}
    func willFetchPhotos(at indexPath: IndexPath) {}
    func numberOfPhotos() -> Int { return 0 }
    func imageURL(for indexPath: IndexPath) -> String? {
        didCallImageURL = true
        return nil
    }
    func toggleLike(at indexPath: IndexPath) {
        didCallToggleLike = true
        view?.showLoading(true)
        view?.updateLike(at: IndexPath(row: 0, section: 0), isLiked: true)
    }
    func cellHeight(for indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        return 0
    }
    func configCell(with indexPath: IndexPath) -> PhotoCell? { return nil }
}

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    var isLoading = false
    var didCallUpdateLike = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
    }

    func performBatchUpdates(_ indexPaths: [IndexPath]) {
    }

    func showLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }

    func updateLike(at indexPath: IndexPath, isLiked: Bool) {
        didCallUpdateLike = true
    }
}
