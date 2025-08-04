@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testNumberOfPhotosInitiallyZero() {
        let presenter = ImagesListPresenterSpy()
        XCTAssertEqual(presenter.numberOfPhotos(), 0)
    }
    
    func testViewDidLoadCall() {
        let presenter = ImagesListPresenterSpy()
        let vc = ImagesListViewControllerSpy()
        vc.presenter = presenter
        presenter.view = vc
        
        _ = vc.view
        
        XCTAssertTrue(presenter.didCallViewDidLoad)
    }
    
    func testToggleLoadingIndicator() {
        let presenter = ImagesListPresenterSpy()
        let view = ImagesListViewControllerSpy()
        presenter.view = view
        
        presenter.toggleLike(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(presenter.didCallToggleLike)
        XCTAssertTrue(view.isLoading)
        XCTAssertTrue(view.didCallUpdateLike)
    }
    
    func testShowLoading() {
        let view = ImagesListViewControllerSpy()
        
        view.showLoading(false)
        
        XCTAssertFalse(view.isLoading)
    }

}
