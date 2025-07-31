//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Sultan Akhmetbek on 31.07.2025.
//
@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        vc.presenter = presenter
        presenter.view = vc
        
        _ = vc.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsLoadRequest() {
        let authHelper = AuthHelper()
        let vc = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: authHelper)
        vc.presenter = presenter
        presenter.view = vc
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(vc.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThanOne() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        let isHidden = presenter.hideProgress(progress)
        
        XCTAssertFalse(isHidden)
    }
    
    func testProgressHiddenWhenOne() {
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        let isHidden = presenter.hideProgress(progress)
        
        XCTAssertTrue(isHidden)
    }
    
    func testAuthHelperAuthURL() {
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        let url = authHelper.authURL()
        
        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }
        
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native") else {
            XCTFail("URL is incorrect")
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        
        guard let url = urlComponents.url else {
            XCTFail("URL is incorrect")
            return
        }
        
        let code = authHelper.code(from: url)
        
        XCTAssertEqual(code, "test code")
    }
}
