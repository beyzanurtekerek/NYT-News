//
//  APICaller.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import Foundation

struct Constants {
    static let API_KEY = Config.apiKey
    static let baseURL = "https://api.nytimes.com/svc/"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    
    func getTopStoriesHome(completion: @escaping (Result<[New], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)topstories/v2/home.json?api-key=\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(NewResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func getTopStoriesWorld(completion: @escaping (Result<[New], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)topstories/v2/world.json?api-key=\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(NewResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    // ARTICLE SEARCH yapılacak
    
}
