//
//  DateFormatter.swift
//  NYT-News
//
//  Created by Beyza Nur Tekerek on 11.04.2025.
//

import Foundation

class DateFormatterUtils {
    static func formattedDate(from string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = formatter.date(from: string) {
            formatter.dateFormat = "dd MMM yyyy - HH:mm:ss"
            return formatter.string(from: date)
        }
        return string
    }
}
