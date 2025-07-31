//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 31.07.2025.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ progress: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    var view: WebViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard var request = authHelper.authRequest() else {
            return
        }
        
        view?.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ progress: Double) {
        let newValue = Float(progress)
        view?.setProgress(newValue)
        
        let isHidden = hideProgress(newValue)
        view?.setProgressHidden(isHidden)
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
    
    func hideProgress(_ value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
