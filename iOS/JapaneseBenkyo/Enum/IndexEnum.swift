//
//  IndexEnum.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.12.02.
//

import UIKit

enum IndexEnum: String, CaseIterable {
    case bookmark = "즐겨찾기"
    case hiragana = "히라가나"
    case katakana = "가타카나"
    case elementary1 = "소학교 1학년"
    case elementary2 = "소학교 2학년"
    case elementary3 = "소학교 3학년"
    case elementary4 = "소학교 4학년"
    case elementary5 = "소학교 5학년"
    case elementary6 = "소학교 6학년"
    case middle = "중학교"
    case n5 = "N5"
    case n4 = "N4"
    case n3 = "N3"
    case n2 = "N2"
    case n1 = "N1"
    
    var section: SectionEnum? {
        switch self {
        case .bookmark:
            return nil
        case .hiragana, .katakana:
            return .hiraganakatagana
        case .elementary1, .elementary2, .elementary3, .elementary4, .elementary5, .elementary6, .middle:
            return .kanji
        case .n5, .n4, .n3, .n2, .n1:
            return .vocabulary
        }
    }
    
    var idRange: ClosedRange<Int> {
        switch self {
        case .bookmark, .hiragana, .katakana:
            return 0...0
        case .elementary1:
            return 0...79
        case .elementary2:
            return 80...239
        case .elementary3:
            return 240...439
        case .elementary4:
            return 440...641
        case .elementary5:
            return 642...834
        case .elementary6:
            return 835...1025
        case .middle:
            return 1026...2135
        case .n5:
            return 0...717
        case .n4:
            return 718...1385
        case .n3:
            return 1386...3524
        case .n2:
            return 3525...5269
        case .n1:
            return 5270...7964
        }
    }
}
