//
//  SearchCollectionViewCell.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 14.04.2025.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {

    static let identifier = "DiscoverCollectionViewCell"
    
    // NESNELER EKLENECEK - DÜZENLENECEK!!!
    
    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let abstractlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let bylineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    public func configure(with model: Doc) {
        headlineLabel.text = model.headline.main
        abstractlabel.text = model.abstract
        dateLabel.text = DateFormatterUtil.formattedDate(from: model.pub_date ?? "")
        sectionLabel.text = model.section_name?.uppercased()
        
        if let imageUrlString = model.multimedia.multimediaDefault?.url,
           let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.searchImageView.image = UIImage(data: data)
                    }
                }
            }
            .resume()
        } else {
            searchImageView.image = UIImage(named: "placeholder")
        }
    }
    
}

