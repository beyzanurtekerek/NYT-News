//
//  SearchVC.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit

class SearchVC: UIViewController {
    
    private var searchNews: [New] = [New]()
    
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        return collectionView
    }()

    private let discoverCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 300, height: 350)
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
    
    private let descriptionLabel: UILabel = {
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
        
        view.addSubview(discoverHeaderLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(searchController.searchBar)
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        discoverCollectionView.delegate = self
        discoverCollectionView.dataSource = self
        
        configureNavbar()
        applyConstraints()
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
            searchController.searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchController.searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        
        
        NSLayoutConstraint.activate(discoverHeaderLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(searchBarConstraints)
    }
    

}

// MARK: - Category Collection View
extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return 10
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            
        }
        
    }
    
    
}
//
//// MARK: - Discover Collection View
//extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//    
//    
//}
