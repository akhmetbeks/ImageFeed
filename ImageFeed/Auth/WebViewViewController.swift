//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 15.06.2025.
//r
import UIKit
import WebKit

public protocol WebViewControllerProtocol: AnyObject {
    var presenter : WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgress(_ progress: Float)
    func setProgressHidden(_ hidden: Bool)
}

final class WebViewViewController: UIViewController, WebViewControllerProtocol {
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?

    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        presenter?.viewDidLoad()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgress(_ progress: Float) {
        progressView.progress = Float(progress)
    }
    
    func setProgressHidden(_ hidden: Bool) {
        progressView.isHidden = hidden
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
