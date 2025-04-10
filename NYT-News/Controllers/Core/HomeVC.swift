//
//  HomeVC.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit

enum Sections: Int {
    case BreakingNews
    case Recommendation
}

class HomeVC: UIViewController {

    let sectionTitles: [String] = ["Breaking News", "Recommendation"]
    
    private var news: [New] = [New]()
    
    private let breakingNewsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 380, height: 250)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BreakingNewsCollectionViewCell.self, forCellWithReuseIdentifier: BreakingNewsCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let recommendationTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(RecommendationTableViewCell.self, forCellReuseIdentifier: RecommendationTableViewCell.identifier)
        return table
    }()
    
    private let breakingNewsHeader: UILabel = {
        let label = UILabel()
        label.text = "Breaking News"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recommendationHeader: UILabel = {
        let label = UILabel()
        label.text = "Recommendation"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(breakingNewsCollectionView)
        view.addSubview(recommendationTableView)
        view.addSubview(breakingNewsHeader)
        view.addSubview(recommendationHeader)
        
        breakingNewsCollectionView.delegate = self
        breakingNewsCollectionView.dataSource = self
        recommendationTableView.delegate = self
        recommendationTableView.dataSource = self
        
        configureNavbar()
        fetchRecommendations()
        fetchBreakingNews()
        applyConstraints()
        
        if let tabBar = self.tabBarController?.tabBar {
            tabBar.backgroundImage = UIImage()
            tabBar.backgroundColor = UIColor.systemBackground.withAlphaComponent(1)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 16
        breakingNewsCollectionView.frame = CGRect(x: 0, y: breakingNewsHeader.frame.maxY + padding , width: view.frame.width, height: 250)
        recommendationTableView.frame = CGRect(x: 0, y: recommendationHeader.frame.maxY + padding, width: view.frame.width, height: view.frame.height)
    }
    
    private func applyConstraints() {
        let breakingNewsHeaderConstraints = [
            breakingNewsHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            breakingNewsHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            breakingNewsHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            breakingNewsHeader.heightAnchor.constraint(equalToConstant: 30)
        ]
        let recommendationHeaderConstraints = [
            recommendationHeader.topAnchor.constraint(equalTo: breakingNewsCollectionView.bottomAnchor, constant: 16),
            recommendationHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recommendationHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recommendationHeader.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        NSLayoutConstraint.activate(recommendationHeaderConstraints)
        NSLayoutConstraint.activate(breakingNewsHeaderConstraints)
    }

    func fetchBreakingNews() {
        APICaller.shared.getTopStoriesHome { [weak self] result in
            switch result {
            case .success(let newsData):
                self?.news = newsData
                DispatchQueue.main.async {
                    self?.breakingNewsCollectionView.reloadData()
                }
            case .failure(let error):
                print("fetch Breaking News Error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchRecommendations() {
        APICaller.shared.getTopStoriesWorld { [weak self] result in
            switch result {
            case .success(let recommendationData):
                self?.news = recommendationData
                DispatchQueue.main.async {
                    self?.recommendationTableView.reloadData()
                }
            case .failure(let error):
                print("fetch Recommendation Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func configureNavbar() {
        let titleLabel = UILabel()
        titleLabel.text = "The New York Times"
        titleLabel.font = UIFont(name: "Times New Roman", size: 27)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        let menuImage = UIImage(systemName: "line.3.horizontal")
        let menuButton = UIBarButtonItem(image: menuImage, style: .done, target: self, action: #selector(menuButtonClicked))
        
        navigationItem.leftBarButtonItem = titleBarButtonItem
        navigationItem.rightBarButtonItem = menuButton
        
        navigationController?.navigationBar.tintColor = .label
        
    }
    
    @objc func menuButtonClicked() {
        // İSLEMLER
        print("hamburger menu button clicked...")
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreakingNewsCollectionViewCell.identifier, for: indexPath) as? BreakingNewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = news[indexPath.row]
        cell.configure(with: model)
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }

    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard news.count > indexPath.row else {
            return UITableViewCell() // Eğer veri yoksa boş hücre döndür
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendationTableViewCell.identifier, for: indexPath) as? RecommendationTableViewCell else {
            return UITableViewCell()
        }
        let model = news[indexPath.row]
        cell.configure(with: model)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.alpha = 1
    }
}

extension HomeVC: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell() {
         // protocol ile birlitke yaz
    }
}
