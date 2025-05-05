//
//  CategoryCollectionViewCell.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 14.04.2025.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
        
    static let identifier = "CategoryCollectionViewCell"
        
    private let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(sectionTitleLabel)
    }
    
    private func applyConstraints() {
        let sectionTitleLabelConstraints = [
            sectionTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            sectionTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sectionTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(sectionTitleLabelConstraints)
    }
    
    public func configure(with title: String, isSelected: Bool) {
        sectionTitleLabel.text = title
        contentView.backgroundColor = isSelected ? .systemCyan : .secondarySystemBackground
        sectionTitleLabel.textColor = isSelected ? .white : .label
    }
    
}
