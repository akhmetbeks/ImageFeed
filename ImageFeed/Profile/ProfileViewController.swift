//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 22.05.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let profileImage: UIImageView = {
        let profileImage = UIImageView(image: UIImage(named: "ProfilePhoto"))
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        return profileImage
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Exit"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let label1: UILabel = {
        let label1 = UILabel()
        label1.text = "Екатерина Новикова"
        label1.font = .systemFont(ofSize: 23, weight: .bold)
        label1.textColor = .ypWhite
        label1.translatesAutoresizingMaskIntoConstraints = false
        return label1
    }()
    
    private let label2: UILabel = {
        let label2 = UILabel()
        label2.text = "@ekaterina_nov"
        label2.font = .systemFont(ofSize: 13, weight: .regular)
        label2.textColor = .ypWhite
        label2.translatesAutoresizingMaskIntoConstraints = false
        return label2
    }()
    
    private let label3: UILabel = {
        let label3 = UILabel()
        label3.text = "Hello, world!"
        label3.font = .systemFont(ofSize: 13, weight: .regular)
        label3.textColor = .ypWhite
        label3.translatesAutoresizingMaskIntoConstraints = false
        return label3
    }()
    
    override func viewDidLoad() {
        view.addSubview(profileImage)
        view.addSubview(button)
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            label1.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            label1.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            label1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 8),
            label2.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            label2.trailingAnchor.constraint(equalTo: label1.trailingAnchor),
            
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 8),
            label3.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            label3.trailingAnchor.constraint(equalTo: label1.trailingAnchor),
            
            button.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
