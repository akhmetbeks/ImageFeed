//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Sultan Akhmetbek on 17.06.2025.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
}

enum HTTPMethod: String {
    case post
    case delete
    case get
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
                let response = response,
                let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    print("[dataTask]: \(NetworkError.httpStatusCode(statusCode).localizedDescription)")
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                print("[dataTask]: \(NetworkError.urlRequestError(error).localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                print("[dataTask]: \(NetworkError.urlSessionError.localizedDescription)")
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
    
    func objectTask<T:Decodable>(
        request: URLRequest,
        decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let body = try decoder.decode(T.self, from: data)
                    completion(.success(body))
                } catch {
                    print("[objectTask]: \(error.localizedDescription) - \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("[objectTask]: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        return task
    }
}
