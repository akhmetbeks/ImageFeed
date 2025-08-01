//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Sultan Akhmetbek on 01.08.2025.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText("sultanisabayev2@gmail.com")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("Qazaqhan125!")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tables = app.tables
        let cell = tables.children(matching: .cell).element(boundBy: 0)
        
        print(app.debugDescription)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cell2 = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        
        cell2.buttons[""].tap()
        cell2.buttons[""].tap()
        
        sleep(2)
        
        cell2.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButton = app.buttons[""]
        navBackButton.tap()
    }
    
    func testProfile() throws {
        let _ = app.tables
        
        sleep(2)
        
        
    }
}
