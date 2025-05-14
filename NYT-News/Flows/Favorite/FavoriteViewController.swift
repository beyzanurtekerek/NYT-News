//
//  FavoriteViewController.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {

    // MARK: - Properties
    private let viewModel = FavoriteViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Saved Articles"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DiscoverCollectionViewCell.self, forCellWithReuseIdentifier: DiscoverCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavbar()
        setupUI()
        applyConstraints()
        fetchSavedArticles()
    }
    
    // FavoriteViewController bellekten silinirken NotificationCenter gözlemcisi de kaldırılıyor. Bu sayede potansiyel memory leak riski ortadan kalkmış oldu
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func refreshData() {
        viewModel.fetchSavedArticles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: .didChangeSavedStatus, object: nil)
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
    }
    
    // MARK: - Constraints
    private func applyConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ]
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(collectionViewConstraints)
    }
    
    // MARK: - Data Fetching
    private func fetchSavedArticles() {
        viewModel.fetchSavedArticles()
    }
    
    // MARK: - UI Updates
    func updateUI() {
        self.collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate & DataSource
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.savedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCollectionViewCell.identifier, for: indexPath) as? DiscoverCollectionViewCell else {
            return UICollectionViewCell()
        }
        let newModel = viewModel.articleAsNew(at: indexPath.row)
        cell.configureWithNew(with: newModel)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 32
        return CGSize(width: width, height: 350)
    }
}

// MARK: - FavoriteViewModelDelegate
extension FavoriteViewController: FavoriteViewModelDelegate {
    func didFetchSavedArticles(_ articles: [SavedArticle]) {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    func showToast(message: String) {
        DispatchQueue.main.async {
            self.view.showToast(message: message)
        }
    }
}

// MARK: - DiscoverCollectionViewCellDelegate
extension FavoriteViewController: DiscoverCollectionViewCellDelegate {
    func didTapSaveButton(on cell: DiscoverCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let article = viewModel.savedArticles[indexPath.item]
        viewModel.toggleSaveStatus(for: article, indexPath: indexPath)
    }
}
