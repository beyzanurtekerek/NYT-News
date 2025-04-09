//
//  BreakingNewsCollectionViewCell.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit

class BreakingNewsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BreakingNewsCollectionViewCell"
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(articleImageView)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        articleImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String) {
        guard let url = URL(string: "") else { return }
    }
    
}
