//
//  Config.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 9.04.2025.
//

import Foundation

struct Config {
    
    static let apiKey: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path),
              let apiKey = config["NYT_API_KEY"] as? String else {
            fatalError("Config.plist file or NYT_API_KEY is not find!")
        }
        return apiKey
    }()
    
}
