//
//  HomeViewModel.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 5.05.2025.
//

import Foundation

class HomeViewModel {
    var breakingNews: [New] = []
    var recommendations: [New] = []
    
    private let apiCaller: NewsAPI
    
    init(apiCaller: NewsAPI = APICaller.shared) {
        self.apiCaller = apiCaller
    }
    
    func fetchNews(for category: String, completion: @escaping ([New]) -> Void) {
        apiCaller.getTopStories(for: category) { result in
            switch result {
            case .success(let newsData):
                if category == "home" {
                    self.breakingNews = newsData
                } else if category == "technology" {
                    self.recommendations = newsData
                }
                completion(newsData)
            case .failure(let error):
                print("fetch News for \(category.capitalized) Error: \(error.localizedDescription)")
                completion([])
            }
        }
    }

    func fetchBreakingNews(completion: @escaping ([New]) -> Void) {
        fetchNews(for: "home", completion: completion)
    }

    func fetchRecommendations(completion: @escaping ([New]) -> Void) {
        fetchNews(for: "technology", completion: completion)
    }
    
    func breakingNewsItem(at index: Int) -> New? {
        guard index < breakingNews.count else { return nil }
        return breakingNews[index]
    }
    
    func recommendationItem(at index: Int) -> New? {
        guard index < recommendations.count else { return nil }
        return recommendations[index]
    }
}
