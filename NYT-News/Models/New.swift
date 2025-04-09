//
//  News.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import Foundation

struct NewResponse: Codable {
    let results: [New]
}

struct New: Codable {
    let section: String?
    let title: String?
    let abstract: String?
    let url: String?
    let byline: String?
    let published_date: String?
    let multimedia: [Multimedia]?
}

struct Multimedia: Codable {
    let url: String?
}

// Top Stories API - Home & World
