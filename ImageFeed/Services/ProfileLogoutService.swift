//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 19.07.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
   static let shared = ProfileLogoutService()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
  
    private init() { }

    func logout() {
        profileService.cleanProfile()
        profileImageService.cleanUserResult()
        imagesListService.cleanPhotos()
        cleanCookies()
    }

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)

        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
    
