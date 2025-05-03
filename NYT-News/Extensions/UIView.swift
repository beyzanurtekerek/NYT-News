//
//  UIView.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 3.05.2025.
//

import UIKit

extension UIView {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        print("showToast called")
        DispatchQueue.main.async {
            let toastLabel = PaddingLabel()
            toastLabel.backgroundColor = .systemGreen
            toastLabel.textColor = .white
            toastLabel.textAlignment = .center
            toastLabel.font = UIFont.systemFont(ofSize: 14.0)
            toastLabel.text = message
            toastLabel.layer.shadowColor = UIColor.black.cgColor
            toastLabel.alpha = 0.0
            toastLabel.layer.cornerRadius = 8
            toastLabel.clipsToBounds = true
            toastLabel.numberOfLines = 0
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(toastLabel)
            
            NSLayoutConstraint.activate([
                toastLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                toastLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
                toastLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, constant: -60)
            ])
            
            UIView.animate(withDuration: 1.0, animations: {
                toastLabel.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: 1.0, delay: 2.0, options: [], animations: {
                    toastLabel.alpha = 0.0
                }, completion: { _ in
                    toastLabel.removeFromSuperview()
                })
            })
        }
    }
}
