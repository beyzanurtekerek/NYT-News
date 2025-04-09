//
//  BreakingNewsCollectionViewCell.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit
import SDWebImage

class BreakingNewsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BreakingNewsCollectionViewCell"
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let abstractLabel: UILabel = {
      let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 4
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sectionLabel: UILabel = {
      let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(abstractLabel)
        contentView.addSubview(dateLabel)
        
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        articleImageView.frame = contentView.bounds
    }
    
    public func configure(with model: New) {
        guard let firstMedia = model.multimedia?.first,
              let urlString = firstMedia.url,
              let url = URL(string: urlString) else { return }
        
        articleImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.title
        abstractLabel.text = model.abstract
        dateLabel.text = model.published_date
    }
    
    // CONSTRAİNT VERİLECEK ??
    private func applyConstraints() {
        //let articleImageViewConstraints = [ ]
            
    }
    
}
