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
           
        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
           
        let profileViewController = ProfileViewController()
        let presenter = ProfilePresenter()
        profileViewController.presenter = presenter
        profileViewController.tabBarItem = UITabBarItem(title: "", image: UIImage(resource: .tabProfileActive), selectedImage: nil)
        presenter.view = profileViewController
          
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
