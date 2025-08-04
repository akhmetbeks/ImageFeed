//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 17.06.2025.
//

import Foundation

final class OAuth2Service {
    private let decoder = JSONDecoder()
    static let shared = OAuth2Service()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest {
        let baseURL = Constants.defaultBaseURL
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
        guard lastCode != code else {
            print("Предыдущий код не соответствует новому")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        let url = makeOAuthTokenRequest(code: code)
        
        let task = URLSession.shared.objectTask(request: url) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let body):
                let response = body
                completion(.success(response.accessToken))
            case .failure(let error):
                print("[fetchOAuthToken]: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self.task = nil
            self.lastCode = nil
        }
        
        self.task = task
        task.resume()
    }
}
