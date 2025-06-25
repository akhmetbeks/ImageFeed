//
//  Profile.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 21.06.2025.
//

struct Profile {
    let username: String
    let firstName: String
    let lastName: String?
    var name: String {
        return "\(firstName) \(lastName ?? "")"
    }
    var loginName: String {
        return "@\(username)"
    }
    let bio: String?
    
}
