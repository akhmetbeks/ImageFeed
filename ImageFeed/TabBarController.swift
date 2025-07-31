//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 25.06.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
           
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
           
        let profileViewController = ProfileViewController()
        let presenter = ProfilePresenter()
        profileViewController.presenter = presenter
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        presenter.view = profileViewController
          
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
