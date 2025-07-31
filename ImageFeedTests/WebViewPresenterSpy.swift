//
//  WebViewPresenterSpy.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 31.07.2025.
//

import ImageFeed
import Foundation
import UIKit

final class WebViewViewControllerSpy: UIViewController, WebViewControllerProtocol {
    var loadRequestCalled = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgress(_ progress: Float) {
        
    }
    
    func setProgressHidden(_ hidden: Bool) {
        
    }
    
    
}

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled = false
    var view: WebViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ progress: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}

