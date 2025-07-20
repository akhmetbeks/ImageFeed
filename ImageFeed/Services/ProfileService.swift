//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 21.06.2025.
//

import Foundation

final class ProfileService {
    private let decoder = JSONDecoder()
    private var task: URLSessionTask?
    private var isProcessing = false
    private(set) var profile: Profile?
    
    static let shared = ProfileService()
    
    private init() {}
    
    private func makeOAuthTokenRequest(accessToken: String) -> URLRequest {
        let baseURL = URL(string: "https://api.unsplash.com")
        let url = URL(
            string: "/me",
            relativeTo: baseURL
        )!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
     }
    
    func cleanProfile() {
        profile = nil
    }
    
    func fetchProfile(token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if isProcessing {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        
        let url = makeOAuthTokenRequest(accessToken: token)
        
        let task = URLSession.shared.objectTask(request: url) { [weak self] (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let body):
                guard let self else { return }
                let profile = Profile(
                    username: body.username,
                    firstName: body.firstName,
                    lastName: body.lastName,
                    bio: body.bio)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                print("[loadProfile]: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            guard let self else { return }
            self.task = nil
            self.isProcessing = false
        }
        
        self.task = task
        self.isProcessing = true
        task.resume()
    }
}
