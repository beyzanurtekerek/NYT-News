//
//  SearchVM.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 15.04.2025.
//

import Foundation

struct SearchResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let docs: [Doc]
}

struct Doc: Codable {
    let abstract: String?
    let byline: Byline
    let multimedia: SearchMultimedia
    let pubDate: String?
    let headline: Headline
    let sectionName: String?
    
    enum CodingKeys: String, CodingKey {
        case abstract
        case byline
        case multimedia
        case pubDate = "pub_date"
        case headline
        case sectionName = "section_name"
    }
}

struct Byline: Codable {
    let original: String?
}

struct SearchMultimedia: Codable {
    let multimediaDefault: Default?
    
    enum CodingKeys: String, CodingKey {
        case multimediaDefault = "default"
    }
}

struct Default: Codable {
    let url: String?
}

struct Headline: Codable {
    let main: String?
}
