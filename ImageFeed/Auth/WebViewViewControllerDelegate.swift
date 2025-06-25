//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 15.06.2025.
//

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
