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
    
    private var breakingNews: [New] = [New]()
    private var recommendations: [New] = [New]()
    
    private let breakingNewsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 380, height: 250)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BreakingNewsCollectionViewCell.self, forCellWithReuseIdentifier: BreakingNewsCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let recommendationTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(RecommendationTableViewCell.self, forCellReuseIdentifier: RecommendationTableViewCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
    private let breakingNewsHeader: UILabel = {
        let label = UILabel()
        label.text = "Breaking News"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recommendationHeader: UILabel = {
        let label = UILabel()
        label.text = "Recommendation"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(breakingNewsHeader)
        view.addSubview(breakingNewsCollectionView)
        view.addSubview(recommendationHeader)
        view.addSubview(recommendationTableView)
        view.addSubview(pageControl)
        
        breakingNewsCollectionView.backgroundColor = .clear
        recommendationTableView.backgroundColor = .clear
        
        breakingNewsCollectionView.delegate = self
        breakingNewsCollectionView.dataSource = self
        recommendationTableView.delegate = self
        recommendationTableView.dataSource = self
        
        configureNavbar()
        fetchRecommendations()
        fetchBreakingNews()
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 16
        
        breakingNewsCollectionView.frame = CGRect(
            x: 0,
            y: breakingNewsHeader.frame.maxY + padding,
            width: view.frame.width,
            height: 250
        )
        pageControl.frame = CGRect(
            x: (view.frame.width - 200) / 2,
            y: breakingNewsCollectionView.frame.maxY + padding,
            width: 200,
            height: 20
        )
        recommendationTableView.frame = CGRect(
            x: 0,
            y: recommendationHeader.frame.maxY,
            width: view.frame.width,
            height: view.frame.height
        )
    }
    
    private func applyConstraints() {
        let breakingNewsHeaderConstraints = [
            breakingNewsHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            breakingNewsHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            breakingNewsHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            breakingNewsHeader.heightAnchor.constraint(equalToConstant: 30)
        ]
        let recommendationHeaderConstraints = [
            recommendationHeader.topAnchor.constraint(equalTo: breakingNewsCollectionView.bottomAnchor, constant: 60),
            recommendationHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recommendationHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recommendationHeader.heightAnchor.constraint(equalToConstant: 25)        ]
        
        NSLayoutConstraint.activate(recommendationHeaderConstraints)
        NSLayoutConstraint.activate(breakingNewsHeaderConstraints)
    }
    
    func fetchBreakingNews() {
        APICaller.shared.getTopStoriesHome { [weak self] result in
            switch result {
            case .success(let newsData):
                self?.breakingNews = newsData
                DispatchQueue.main.async {
                    self?.breakingNewsCollectionView.reloadData()
                    self?.pageControl.numberOfPages = newsData.count
                }
            case .failure(let error):
                print("fetch Breaking News Error: \(error.localizedDescription)")
            }
        }
    }
        
    func fetchRecommendations() {
        APICaller.shared.getTopStoriesTech { [weak self] result in
            switch result {
            case .success(let recommendationData):
                self?.recommendations = recommendationData
                DispatchQueue.main.async {
                    self?.recommendationTableView.reloadData()
                }
            case .failure(let error):
                print("fetch Recommendation Error: \(error.localizedDescription)")
            }
        }
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breakingNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreakingNewsCollectionViewCell.identifier, for: indexPath) as? BreakingNewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = breakingNews[indexPath.row]
        cell.configure(with: model)
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = breakingNews[indexPath.row]
        let vc = DetailVC()
        vc.news = selectedNews
        vc.configure(with: selectedNews)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard recommendations.count > indexPath.row else {
            return UITableViewCell()
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendationTableViewCell.identifier, for: indexPath) as? RecommendationTableViewCell else {
            return UITableViewCell()
        }
        let model = recommendations[indexPath.row]
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == breakingNewsCollectionView {
            let pageWidth = breakingNewsCollectionView.frame.width
            let currentPage = Int(breakingNewsCollectionView.contentOffset.x / pageWidth)
            pageControl.currentPage = currentPage
        } else if scrollView == recommendationTableView {
            navigationController?.navigationBar.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = recommendations[indexPath.row]
        let vc = DetailVC()
        vc.news = selectedNews
        vc.configure(with: selectedNews)
        navigationController?.pushViewController(vc, animated: true)
    }
}
