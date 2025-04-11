//
//  UIViewController+NavBar.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 11.04.2025.
//

import Foundation
import UIKit

extension UIViewController {
    func configureNavbar() {
        let titleLabel = UILabel()
        titleLabel.text = "The New York Times"
        titleLabel.font = UIFont(name: "Times New Roman", size: 30)
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
        // Menu işlemleri
        print("hamburger menu button clicked...")
    }
}

