//
//  SearchVC.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit

class SearchVC: UIViewController {
    
    private var searchNews: [New] = [New]()
    private var searchResults: [Doc] = [Doc]()
    private let categories = [
        "World",
        "Technology",
        "Business",
        "Sports",
        "Science",
        "Health",
        "Arts",
        "Politics",
        "Travel",
        "Style"
    ]
    private var selectedCategoryIndex = 0

    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 30)
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
        layout.itemSize = CGSize(width: 300, height: 350)
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DiscoverCollectionViewCell.self, forCellWithReuseIdentifier: DiscoverCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let discoverHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover"
        label.font = UIFont.boldSystemFont(ofSize: 40)
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
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search for news..."
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.translatesAutoresizingMaskIntoConstraints = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(categoryCollectionView)
        view.addSubview(discoverCollectionView)
        view.addSubview(discoverHeaderLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(searchController.searchBar)
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        discoverCollectionView.delegate = self
        discoverCollectionView.dataSource = self
        searchController.searchResultsUpdater = self
        
        configureNavbar()
        applyConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 16
        let searchBarBottom = searchController.searchBar.frame.maxY
        
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
            discoverHeaderLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: discoverHeaderLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ]
        let searchBarConstraints = [
            searchController.searchBar.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            searchController.searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchController.searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ]

        NSLayoutConstraint.activate(discoverHeaderLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(searchBarConstraints)
    }
    

}
// MARK: - Category and Discover Collection View
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        } else if collectionView == discoverCollectionView {
            return searchResults.count
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
            let result = searchResults[indexPath.item]
            cell.configure(with: result)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            selectedCategoryIndex = indexPath.item
            
            let selectedCategory = categories[selectedCategoryIndex]
            APICaller.shared.fetchNews(for: selectedCategory) { [weak self] result in
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
            categoryCollectionView.reloadData()
        } else if collectionView == discoverCollectionView {
            // islemler
        }
    }
}

extension SearchVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            let selectedCategory = categories[selectedCategoryIndex]
            APICaller.shared.fetchNews(for: selectedCategory) { [weak self] result in
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
        
        APICaller.shared.search(with: query) { [weak self] result in
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
    
    
}
