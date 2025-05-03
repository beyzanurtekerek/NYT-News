//
//  SearchVC.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit

class SearchVC: UIViewController {
    
    private var searchWorkItem: DispatchWorkItem?
    private var searchNews: [New] = [New]()
    private var searchResults: [Doc] = [Doc]()
    private let categories = [
        "World",
        "Technology",
        "Business",
        "Sports",
        "Food",
        "Science",
        "Movies",
        "Books/review",
        "Automobiles",
        "Health",
        "Arts",
        "Politics",
        "Travel",
        "Style",
        "Magazine",
        "Fashion"
    ]
    private var selectedCategoryIndex = 0
    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private let discoverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DiscoverCollectionViewCell.self, forCellWithReuseIdentifier: DiscoverCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let discoverHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover"
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Find the latest news articles"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search for news..."
        bar.searchBarStyle = .minimal
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(categoryCollectionView)
        view.addSubview(discoverCollectionView)
        view.addSubview(discoverHeaderLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(searchBar)
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        discoverCollectionView.delegate = self
        discoverCollectionView.dataSource = self
        searchBar.delegate = self
        
        configureNavbar()
        applyConstraints()
        fetchInitialCategoryNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 16
        let searchBarBottom = searchBar.frame.maxY
        
        categoryCollectionView.frame = CGRect(
            x: 0,
            y: searchBarBottom + padding,
            width: view.frame.width,
            height: 30
        )
        discoverCollectionView.frame = CGRect(
            x: 0,
            y: categoryCollectionView.frame.maxY + padding,
            width: view.frame.width,
            height: view.frame.height - categoryCollectionView.frame.maxY - padding
        )
    }
    
    
    private func applyConstraints() {
        let discoverHeaderLabelConstraints = [
            discoverHeaderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            discoverHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            discoverHeaderLabel.heightAnchor.constraint(equalToConstant: 40)
        ]
        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: discoverHeaderLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ]
        let searchBarConstraints = [
            searchBar.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ]

        NSLayoutConstraint.activate(discoverHeaderLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(searchBarConstraints)
    }
    
    private func fetchInitialCategoryNews() {
        let selectedCategory = categories[selectedCategoryIndex]
        APICaller.shared.fetchNews(for: selectedCategory) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let news):
                    self?.searchNews = news
                    self?.discoverCollectionView.reloadData()
                case .failure(let error):
                    print("Initial fetch error: \(error.localizedDescription)")
                }
            }
        }
    }

}
// MARK: - Category and Discover Collection View
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            print("Search News Count: \(searchNews.count)")
            return categories.count
        } else if collectionView == discoverCollectionView {
            print("Search Results Count: \(searchResults.count)")
            return searchBar.text?.isEmpty == false ? searchResults.count : searchNews.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: categories[indexPath.item], isSelected: indexPath.item == selectedCategoryIndex)
            return cell
        } else if collectionView == discoverCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCollectionViewCell.identifier, for: indexPath) as? DiscoverCollectionViewCell else {
                return UICollectionViewCell()
            }
            if searchBar.text?.isEmpty == false {
                let result = searchResults[indexPath.item]
                cell.configure(with: result)
                cell.delegate = self
            } else {
                let news = searchNews[indexPath.item]
                cell.configure(with: news)
                cell.delegate = self
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            selectedCategoryIndex = indexPath.item
            
            searchBar.text = ""
            
            let selectedCategory = categories[selectedCategoryIndex]
            APICaller.shared.fetchNews(for: selectedCategory) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let news):
                        let filteredNews = news.filter { $0.section?.lowercased() == selectedCategory.lowercased()}
                        self?.searchNews = filteredNews
                        self?.discoverCollectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            categoryCollectionView.reloadData()
        } else if collectionView == discoverCollectionView {
            // search vc de haber cell tıklanırsa yapılacaklar burada
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: 100, height: 30)
        } else if collectionView == discoverCollectionView {
            let width = collectionView.bounds.width - 32
            return CGSize(width: width, height: 450)
        }
        return .zero
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            guard !searchText.isEmpty else {
                let selectedCategory = self?.categories[self?.selectedCategoryIndex ?? 0] ?? ""
                APICaller.shared.fetchNews(for: selectedCategory) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let news):
                            self?.searchNews = news
                            self?.discoverCollectionView.reloadData()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
                return
            }
            
            APICaller.shared.search(with: searchText) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let results):
                        self?.searchResults = results
                        self?.discoverCollectionView.reloadData()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}

// MARK: - DiscoverCollectionViewCellDelegate
extension SearchVC: DiscoverCollectionViewCellDelegate {
    func didTapSaveButton(on cell: DiscoverCollectionViewCell) {
        if let indexPath = discoverCollectionView.indexPath(for: cell) {
            discoverCollectionView.reloadItems(at: [indexPath])
        }
    }
}
