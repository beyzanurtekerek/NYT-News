//
//  SearchVC.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit

class SearchVC: UIViewController {
    
    private var searchNews: [New] = [New]()

    private let discoverHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Find the latest news articles from around the world"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Search for news..."
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavbar()
        // applyC
    }
    
    
    private func applyConstraints() {
        let discoverHeaderLabelConstraints = [
            discoverHeaderLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            discoverHeaderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ]
        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: discoverHeaderLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ]
        
        
        
        NSLayoutConstraint.activate(discoverHeaderLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
    }
    
    
    

}
