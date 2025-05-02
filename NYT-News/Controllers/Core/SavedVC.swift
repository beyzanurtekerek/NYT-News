//
//  SavedVC.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit
import CoreData

class SavedVC: UIViewController {

    private var savedArticles: [SavedArticle] = []
    
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
        return collectionView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureNavbar()
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 16
        
        collectionView.frame = CGRect(
            x: 0,
            y: titleLabel.frame.maxY + padding,
            width: view.frame.width,
            height: view.frame.height - titleLabel.frame.maxY - padding
        )
    }
    
    private func applyConstraints() {
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
}

extension SavedVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverCollectionViewCell.identifier, for: indexPath) as? DiscoverCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let article = savedArticles[indexPath.row]
        
        let multimedia: [Multimedia]? = {
            if let imageUrl = article.imageUrl {
                return [Multimedia(url: imageUrl)]
            } else {
                return nil
            }
        }()
        
        let newModel = New(
            section: article.section ?? "",
            title: article.title ?? "",
            abstract: article.abstractText ?? "",
            url: article.url ?? "",
            byline: article.byline ?? "",
            published_date: article.publishedDate,
            multimedia: multimedia
        )
        
        cell.configure(with: newModel)
        return cell
    }
    
    
}
