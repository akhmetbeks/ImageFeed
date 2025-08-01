//
//  ProfilePresenterSpy.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 01.08.2025.
//

import ImageFeed
import UIKit

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerDelegate {
    var alertPresented = false
    
    func presentAlert(_ alert: UIAlertController) {
        alertPresented = true
    }
    
    func showAvatar(_ url: URL) {
        
    }
    
    
}

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var isLoggedOut = false
    
    func switchToSplashController() {
        isLoggedOut = true
    }
    
    func showConfirmationAlert() {
        
    }
    
    func logout() {
        
    }
    
    func updateAvatar() {
        
    }
}
