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
        
        // Border ekleme kısmı
        let border = UIView()
        border.backgroundColor = .lightGray  // Çizginin rengini ayarlayabilirsiniz
        border.translatesAutoresizingMaskIntoConstraints = false
        navigationController?.navigationBar.addSubview(border)
        
        NSLayoutConstraint.activate([
            border.heightAnchor.constraint(equalToConstant: 0.4),  // Çizgi kalınlığı
            border.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor),
            border.leadingAnchor.constraint(equalTo: navigationController!.navigationBar.leadingAnchor),
            border.trailingAnchor.constraint(equalTo: navigationController!.navigationBar.trailingAnchor)
        ])

    }
    
    @objc func menuButtonClicked() {
        // Menu işlemleri
        print("hamburger menu button clicked...")
    }
}

