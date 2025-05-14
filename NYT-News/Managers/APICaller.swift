//
//  APICaller.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import Foundation
// buraya kadar
struct Constants {
    static let API_KEY = Config.apiKey
    static let baseURL = "https://api.nytimes.com/svc/"
}

enum APIError: Error {
    case failedToGetData
}

protocol NewsAPI {
    func getTopStories(for category: String, completion: @escaping (Result<[New], Error>) -> Void)
    func search(with query: String, completion: @escaping (Result<[Doc], Error>) -> Void)
    func fetchNews(for category: String, completion: @escaping (Result<[New], Error>) -> Void)
}

class APICaller: NewsAPI {
    
    static let shared = APICaller()
    
    func getTopStories(for category: String, completion: @escaping (Result<[New], Error>) -> Void) {
        let categoryLowercased = category.lowercased()
        guard let url = URL(string: "\(Constants.baseURL)topstories/v2/\(categoryLowercased).json?api-key=\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let result = try JSONDecoder().decode(NewResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    func search(with query: String, completion: @escaping (Result<[Doc], Error>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        guard let url = URL(string: "\(Constants.baseURL)search/v2/articlesearch.json?q=\(query)&api-key=\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let results = try JSONDecoder().decode(SearchResponse.self, from: data)
                completion(.success(results.response.docs))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }

    func fetchNews(for category: String, completion: @escaping (Result<[New], Error>) -> Void) {
        let categoryLowercased = category.lowercased()
        guard let url = URL(string: "\(Constants.baseURL)topstories/v2/\(categoryLowercased).json?api-key=\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            do {
                let results = try JSONDecoder().decode(NewResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
}
