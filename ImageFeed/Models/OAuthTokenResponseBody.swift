//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 17.06.2025.
//

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}
