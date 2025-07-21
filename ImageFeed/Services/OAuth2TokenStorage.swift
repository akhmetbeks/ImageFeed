//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 17.06.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    private let tokenKey = "access_token"
    
    var token: String? {
        get {
            let token = KeychainWrapper.standard.string(forKey: tokenKey)
            return token
        }
        set {
            guard let newValue else { return }
            KeychainWrapper.standard.set(newValue, forKey: tokenKey)
        }
    }
}
