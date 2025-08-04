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
        app.buttons["Войти"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        loginTextField.tap()
        loginTextField.typeText("sultanisabayev2@gmail.com")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("Qazaqhan125!")
        sleep(1)
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tables = app.tables
        let cell = tables.children(matching: .cell).element(boundBy: 0)
        
        print(app.debugDescription)
        XCTAssertTrue(cell.waitForExistence(timeout: 10))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let firstCell = tablesQuery.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
        
        firstCell.swipeUp()
        
        let secondCell = tablesQuery.descendants(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(secondCell.waitForExistence(timeout: 5))
        
        let likeButton = secondCell.buttons["No Active"]
        XCTAssertTrue(likeButton.waitForExistence(timeout: 5))
        likeButton.tap()
        
        let secondLikeButton = secondCell.buttons["Active"]
        XCTAssertTrue(secondLikeButton.waitForExistence(timeout: 5))
        
        secondCell.tap()
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        
        let navBackButton = app.buttons["Backward"]
        XCTAssertTrue(navBackButton.waitForExistence(timeout: 5))
        
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        navBackButton.tap()
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5))
    }
    
    func testProfile() throws {
        let table = app.tables.element(boundBy: 0)
        XCTAssertTrue(table.waitForExistence(timeout: 5))
        
        app.tabBars.buttons["ProfileTab"].tap()
        
        let exitButton = app.buttons["ExitButton"]
        XCTAssertTrue(exitButton.waitForExistence(timeout: 5))
        exitButton.tap()
        
        let alert = app.alerts.element(boundBy: 0)
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.buttons["OK"].tap()
        
        let button = app.buttons["Войти"]
        XCTAssertTrue(button.waitForExistence(timeout: 5))
    }
}
