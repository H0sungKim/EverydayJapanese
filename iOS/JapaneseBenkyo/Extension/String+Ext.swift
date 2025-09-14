//
//  File.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.09.14.
//

import Foundation

extension String {
    subscript (safe range: Range<String.Index>) -> Substring? {
        return range.lowerBound >= startIndex && range.upperBound <= endIndex ? self[range] : nil
    }
}
