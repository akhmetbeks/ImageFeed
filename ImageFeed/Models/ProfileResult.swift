//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 21.06.2025.
//

struct ProfileResult: Decodable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio = "bio"
    }
}
