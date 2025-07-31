//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 15.06.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    static let webViewSegueIdentifier = "ShowWebView"
    let oauth2Service = OAuth2Service.shared
    let storage = OAuth2TokenStorage.shared
    weak var delegate: AuthViewControllerDelegate?
    private let uiBlockingProgressHUD = UIBlockingProgressHUD()
    
    override func viewDidLoad() {
        configureBackButton()
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .cancel)
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AuthViewController.webViewSegueIdentifier {
            guard
                let destination = segue.destination as? WebViewViewController
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let authHelper = AuthHelper()
            let presenter = WebViewPresenter(authHelper: authHelper)
            destination.presenter = presenter
            presenter.view = destination
            destination.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController,
                               didAuthenticateWithCode code: String) {
        self.uiBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            self?.uiBlockingProgressHUD.dismiss()
            switch result {
            case .success(let token):
                guard let self else {   return  }
                self.storage.token = token
                guard let delegate = self.delegate else {   return  }
                delegate.didAuthenticate(self)
            case .failure(let error):
                self?.showAlert()
                print(error.localizedDescription)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
