//
//  ProfileTests.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 01.08.2025.
//
@testable import ImageFeed
import Foundation
import XCTest

final class ProfileTests: XCTestCase {
    func testAlertPresented() {
        let presenter = ProfilePresenter()
        let view = ProfileViewControllerSpy()
        presenter.view = view
        
        presenter.showConfirmationAlert()
        
        XCTAssertTrue(view.alertPresented)
    }
    
    func testLogout() {
        let presenter = ProfilePresenterSpy()
        
        presenter.logout()
        
        XCTAssertTrue(presenter.isLoggedOut)
    }
}
