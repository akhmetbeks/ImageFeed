//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 17.06.2025.
//

import Foundation

final class OAuth2TokenStorage {
    private let tokenKey = "access_token"
    
    var token: String? {
        get {
            UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
