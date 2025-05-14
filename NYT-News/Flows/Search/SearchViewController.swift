//
//  SearchViewController.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var searchWorkItem: DispatchWorkItem?
    private let viewModel = SearchViewModel()
    
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
                        
        configureNavbar()
        setupUI()
        applyConstraints()
        viewModel.onNewsUpdated = { [weak self] in
            self?.discoverCollectionView.reloadData()
        }
        viewModel.fetchInitialCategoryNews()
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
    
    private func setupUI() {
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

        let allConstraints = [
            discoverHeaderLabelConstraints,
            descriptionLabelConstraints,
            searchBarConstraints
        ].flatMap { $0 }
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
}
// MARK: - Category and Discover Collection View
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return viewModel.categoryCount
        } else if collectionView == discoverCollectionView {
            return searchBar.text?.isEmpty == false ? viewModel.searchResultsCount : viewModel.searchNewsCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            let category = viewModel.category(at: indexPath.item)
            let isSelected = indexPath.item == viewModel.selectedCategoryIndex
            cell.configure(with: category, isSelected: isSelected)
            return cell
        } else if collectionView == discoverCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCollectionViewCell.identifier, for: indexPath) as? DiscoverCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let searchText = searchBar.text, !searchText.isEmpty {
                let result = viewModel.searchResult(at: indexPath.item)
                cell.configureWithDoc(with: result)
            } else {
                let news = viewModel.newsItem(at: indexPath.item)
                cell.configureWithNew(with: news)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            
            searchBar.text = ""
            viewModel.didSelectCategory(at: indexPath.item) { [weak self] in
                self?.categoryCollectionView.reloadData()
            }
                
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

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.viewModel.performSearch(with: searchText) {
                self?.discoverCollectionView.reloadData()
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}

// MARK: - DiscoverCollectionViewCellDelegate
extension SearchViewController: DiscoverCollectionViewCellDelegate {
    func didTapSaveButton(on cell: DiscoverCollectionViewCell) {
        if let indexPath = discoverCollectionView.indexPath(for: cell) {
            discoverCollectionView.reloadItems(at: [indexPath])
        }
    }
}
