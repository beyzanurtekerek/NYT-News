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
    
    func fetchBreakingNews(completion: @escaping ([New]) -> Void) {
        APICaller.shared.getTopStoriesHome { result in
            switch result {
            case .success(let newsData):
                self.breakingNews = newsData
                completion(newsData)
            case .failure(let error):
                print("fetch Breaking News Error: \(error.localizedDescription)")
                completion([])
            }
        }
    }

    func fetchRecommendations(completion: @escaping ([New]) -> Void) {
        APICaller.shared.getTopStoriesTech { result in
            switch result {
            case .success(let newsData):
                self.recommendations = newsData
                completion(newsData)
            case .failure(let error):
                print("fetch Recommendation Error: \(error.localizedDescription)")
                completion([])
            }
        }
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
