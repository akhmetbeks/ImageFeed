//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 18.06.2025.
//

import UIKit

final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    let profileService = ProfileService.shared
    let profileImageService = ProfileImageService.shared
    let storage = OAuth2TokenStorage.shared
    let uiBlockingProgressHUB = UIBlockingProgressHUD()
    private let showAuthIdentifier = "ShowAuth"
    
    private let logo: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "LaunchIcon"))
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(logo)
        
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        if let token = storage.token {
            fetchProfile(token: token)
        } else {
            switchToAuthController()
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    private func switchToAuthController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
        else {
            return
        }
        
        authController.delegate = self
        authController.modalPresentationStyle = .fullScreen
        
        self.present(authController, animated: true)
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = storage.token else {
            return
        }
        
        fetchProfile(token: token)
    }
    
    private func fetchAvatarURL(username: String) {
        profileImageService.fetchAvatarURL(username: username) { _ in }
        self.switchToTabBarController()
    }
    
    private func fetchProfile(token: String) {
        uiBlockingProgressHUB.show()
        profileService.fetchProfile(token: token) { [weak self]  result in
            guard let self else { return }
            self.uiBlockingProgressHUB.dismiss()
            switch result {
                case .success(let profile):
                    fetchAvatarURL(username: profile.username)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
