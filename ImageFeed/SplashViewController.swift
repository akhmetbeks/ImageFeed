//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 18.06.2025.
//

import UIKit

final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    let storage = OAuth2TokenStorage()
    private let showAuthIdentifier = "ShowAuth"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if storage.token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: showAuthIdentifier, sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthIdentifier {
            guard
                let navigation = segue.destination as? UINavigationController,
                let controller = navigation.viewControllers[0] as? AuthViewController
            else {
                return
            }
            
            controller.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        switchToTabBarController()
    }
}
