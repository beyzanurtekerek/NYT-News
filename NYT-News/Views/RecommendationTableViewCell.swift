//
//  RecommendationTableViewCell.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import UIKit
import SDWebImage

class RecommendationTableViewCell: UITableViewCell {

    static let identifier = "RecommendationTableViewCell"
    
    private let populerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let bylineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(populerImageView)
        contentView.addSubview(bylineLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        let populerImageViewConstraints = [
            populerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            populerImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            populerImageView.widthAnchor.constraint(equalToConstant: 90),
            populerImageView.heightAnchor.constraint(equalToConstant: 90)
        ]
        let bylineLabelConstraints = [
            bylineLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bylineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bylineLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: bylineLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: populerImageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
        let dateLabelConstraints = [
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(populerImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(bylineLabelConstraints)
        NSLayoutConstraint.activate(dateLabelConstraints)
    }
    
    public func configure(with model: New) {
        guard let urlString = model.multimedia?.first?.url,
              let url = URL(string: urlString) else { return }
        
        titleLabel.text = model.title
        bylineLabel.text = "• \(model.byline ?? "Unknown Author")"
        dateLabel.text = DateFormatterUtils.formattedDate(from: model.published_date ?? "")
        populerImageView.sd_setImage(with: url)
    }
    
}
