//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 01.08.2025.
//

import ImageFeed
import UIKit

final class ProfileViewControllerSpy: ProfileViewControllerDelegate {
    var alertPresented = false
    
    func presentAlert(_ alert: UIAlertController) {
        alertPresented = true
    }
    
    func showAvatar(_ url: URL) {
        
    }
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerDelegate?
    
    var isLoggedOut = false
    
    func switchToSplashController() {
        view?.presentAlert(UIAlertController())
    }
    
    func showConfirmationAlert() {
        
    }
    
    func logout() {
        isLoggedOut = true
    }
    
    func updateAvatar() {
        
    }
}
