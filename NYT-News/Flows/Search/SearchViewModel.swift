//
//  SearchViewModel.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 6.05.2025.
//

import Foundation

class SearchViewModel {
    private let categories = [
        "World", "Technology", "Business", "Sports", "Food",
        "Science", "Movies", "Books/review", "Automobiles",
        "Health", "Arts", "Politics", "Travel", "Style", "Magazine", "Fashion"
    ]
    
    private(set) var searchNews: [New] = []
    private(set) var searchResults: [Doc] = []
    var selectedCategoryIndex: Int = 0
    
    var onNewsUpdated: (() -> Void)?
    var searchNewsCount: Int {
        return searchNews.count
    }
    var searchResultsCount: Int {
        return searchResults.count
    }
    var categoryCount: Int {
        return categories.count
    }
    
    func fetchInitialCategoryNews() {
        let selectedCategory = categories[selectedCategoryIndex]
        APICaller.shared.fetchNews(for: selectedCategory) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    self?.searchNews = news
                    self?.onNewsUpdated?()
                case .failure(let error):
                    print("Initial fetch error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func didSelectCategory(at index: Int, completion: @escaping () -> Void) {
        selectedCategoryIndex = index
        let selectedCategory = categories[selectedCategoryIndex]
        APICaller.shared.fetchNews(for: selectedCategory) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    let filteredNews = news.filter { $0.section?.lowercased() == selectedCategory.lowercased() }
                    self?.searchNews = filteredNews
                    self?.searchResults = []
                    self?.onNewsUpdated?()
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func performSearch(with searchText: String, completion: @escaping () -> Void) {
        guard !searchText.isEmpty else {
            let selectedCategory = categories[selectedCategoryIndex]
            APICaller.shared.fetchNews(for: selectedCategory) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let news):
                        self?.searchNews = news
                        self?.searchResults = []
                        self?.onNewsUpdated?()
                        completion()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            return
        }

        APICaller.shared.search(with: searchText) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    self?.searchResults = results
                    self?.onNewsUpdated?()
                    completion()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func category(at index: Int) -> String {
        return categories[index]
    }
    
    func newsItem(at index: Int) -> New {
        return searchNews[index]
    }
    
    func searchResult(at index: Int) -> Doc {
        return searchResults[index]
    }
    
    
}
