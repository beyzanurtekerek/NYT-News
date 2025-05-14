//
//  HomeViewController.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit

enum Sections: Int {
    case BreakingNews
    case Recommendation
}

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let sectionTitles: [String] = ["Breaking News", "Recommendation"]
    private let viewModel = HomeViewModel(apiCaller: APICaller.shared)
    
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
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let recommendationTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(RecommendationTableViewCell.self, forCellReuseIdentifier: RecommendationTableViewCell.identifier)
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureNavbar()
        setupUI()
        applyConstraints()
        fetchData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
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
    }
    
    // MARK: - Constraints
    private func applyConstraints() {
        let breakingNewsHeaderConstraints = [
            breakingNewsHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            breakingNewsHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            breakingNewsHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            breakingNewsHeader.heightAnchor.constraint(equalToConstant: 30)
        ]
        let breakingNewsCollectionViewConstraints = [
            breakingNewsCollectionView.topAnchor.constraint(equalTo: breakingNewsHeader.bottomAnchor, constant: 8),
            breakingNewsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            breakingNewsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            breakingNewsCollectionView.heightAnchor.constraint(equalToConstant: 250)
        ]
        let pageControlConstraints = [
            pageControl.topAnchor.constraint(equalTo: breakingNewsCollectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20)
        ]
        let recommendationHeaderConstraints = [
            recommendationHeader.topAnchor.constraint(equalTo: breakingNewsCollectionView.bottomAnchor, constant: 60),
            recommendationHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            recommendationHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            recommendationHeader.heightAnchor.constraint(equalToConstant: 25)
        ]
        let recommendationTableViewConstraints = [
            recommendationTableView.topAnchor.constraint(equalTo: recommendationHeader.bottomAnchor, constant: 8),
            recommendationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recommendationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recommendationTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(breakingNewsHeaderConstraints)
        NSLayoutConstraint.activate(breakingNewsCollectionViewConstraints)
        NSLayoutConstraint.activate(pageControlConstraints)
        NSLayoutConstraint.activate(recommendationHeaderConstraints)
        NSLayoutConstraint.activate(recommendationTableViewConstraints)
    }
    
    // MARK: - Data Fetching
    private func fetchData() {
        viewModel.fetchBreakingNews { [weak self] news in
            DispatchQueue.main.async {
                self?.breakingNews = news
                self?.breakingNewsCollectionView.reloadData()
                self?.pageControl.numberOfPages = news.count
            }
        }
        
        viewModel.fetchRecommendations { [weak self] news in
            DispatchQueue.main.async {
                self?.recommendations = news
                self?.recommendationTableView.reloadData()
            }
        }
    }
    
    // MARK: - Navigation
    private func navigateToDetail(with news: New) {
        let vc = HomeDetailViewController()
        vc.news = news
        vc.configureWithNews(with: news)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - ScrollView Handling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageControlForScrollView(scrollView)
    }
    
    private func updatePageControlForScrollView(_ scrollView: UIScrollView) {
        if scrollView == breakingNewsCollectionView {
            let pageWidth = breakingNewsCollectionView.frame.width
            guard pageWidth > 0 else { return }
            let currentPage = Int(breakingNewsCollectionView.contentOffset.x / pageWidth)
            pageControl.currentPage = currentPage
        } else if scrollView == recommendationTableView {
            navigationController?.navigationBar.alpha = 1
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breakingNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreakingNewsCollectionViewCell.identifier, for: indexPath) as? BreakingNewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let model = viewModel.breakingNewsItem(at: indexPath.row) else {
            return UICollectionViewCell()
        }
        cell.configureWithNews(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedNews = viewModel.breakingNewsItem(at: indexPath.row) else { return }
        navigateToDetail(with: selectedNews)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        guard let model = viewModel.recommendationItem(at: indexPath.row) else {
            return UITableViewCell()
        }
        cell.configureWithNews(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedNews = viewModel.recommendationItem(at: indexPath.row) else { return }
        navigateToDetail(with: selectedNews)
    }
}
