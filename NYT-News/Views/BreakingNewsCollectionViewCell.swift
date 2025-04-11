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
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .white
        label.shadowColor = UIColor.black.withAlphaComponent(0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let abstractLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 4
        label.textColor = .white
        label.shadowColor = UIColor.black.withAlphaComponent(0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor.systemGray.withAlphaComponent(0.6)
        return label
    }()
    
    private let sectionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func formattedDate(from string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = formatter.date(from: string) {
            formatter.dateFormat = "dd MMM yyyy - HH:mm:ss"
            return formatter.string(from: date)
        }
        return string
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(articleImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(abstractLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(sectionLabel)
        
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
        titleLabel.text = model.title
        abstractLabel.text = model.abstract
        dateLabel.text = formattedDate(from: model.published_date ?? "")
        sectionLabel.text = model.section?.uppercased()
        
        if let imageUrlString = model.multimedia?.first?.url,
           let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.articleImageView.image = UIImage(data: data)
                    }
                }
            }
            .resume()
        } else {
            articleImageView.image = UIImage(named: "placeholder")
        }
    }
    
    private func applyConstraints() {
        let articleImageViewConstraints = [
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: 300)
        ]
        let sectionLabelConstraints = [
            sectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sectionLabel.trailingAnchor.constraint(equalTo: sectionLabel.trailingAnchor, constant: -8)
        ]
        let dateLabelConstraints = [
            dateLabel.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: -8)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ]
        let abstractLabelConstraints = [
            abstractLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            abstractLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            abstractLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            abstractLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        
        NSLayoutConstraint.activate(articleImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(abstractLabelConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
        NSLayoutConstraint.activate(sectionLabelConstraints)
    }
    
}
