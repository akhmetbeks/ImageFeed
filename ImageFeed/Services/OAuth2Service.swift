//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 17.06.2025.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest {
        let baseURL = URL(string: Constants.defaultBaseURL)
         let url = URL(
             string: "/oauth/token"
             + "?client_id=\(Constants.accessKey)"
             + "&&client_secret=\(Constants.secretKey)"
             + "&&redirect_uri=\(Constants.redirectURI)"
             + "&&code=\(code)"
             + "&&grant_type=authorization_code",
             relativeTo: baseURL
         )!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         return request
     }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = makeOAuthTokenRequest(code: code)
        
        let task = URLSession.shared.data(for: url) { result in
            switch result {
            case .success(let data):
                do {
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(tokenResponse.accessToken))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(NetworkError.urlSessionError))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
        }
        
        task.resume()
    }
}
