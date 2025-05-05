//
//  Doc.swift
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
    let pub_date: String?
    let headline: Headline
    let section_name: String?
    let web_url: String?
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
