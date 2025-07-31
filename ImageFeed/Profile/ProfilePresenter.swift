//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 31.07.2025.
//

import UIKit
import SwiftKeychainWrapper

public protocol ProfilePresenterProtocol {
    func switchToSplashController()
    func showConfirmationAlert()
    func logout()
    func updateAvatar()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private let profileLogoutService = ProfileLogoutService.shared
    private let profileImageService = ProfileImageService.shared
    var view: ProfileViewControllerDelegate?
    
    func showConfirmationAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )

        let yesAction = UIAlertAction(title: "Да", style: .destructive) { _ in
            self.logout()
        }

        let noAction = UIAlertAction(title: "Нет", style: .cancel)

        alert.addAction(yesAction)
        alert.addAction(noAction)

        view?.presentAlert(alert)
    }
    
    func logout() {
        profileLogoutService.logout()
        KeychainWrapper.standard.remove(forKey: "access_token")
        switchToSplashController()
    }
    
    func switchToSplashController() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        let splashController = SplashViewController()
        
        window.rootViewController = splashController
    }
    
    func updateAvatar() {
        guard
            let image = profileImageService.userResult?.profileImage.small,
            let avatar = URL(string: image)
        else {
            return
        }
        
        view?.showAvatar(avatar)
    }
}
