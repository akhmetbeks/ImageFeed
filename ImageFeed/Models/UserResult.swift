//
//  ProfileImage.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 22.06.2025.
//

struct UserResult: Decodable {
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Decodable {
    let small: String
}

