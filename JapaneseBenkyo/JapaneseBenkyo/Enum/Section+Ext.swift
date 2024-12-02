//
//  Section+Ext.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.12.02.
//

import UIKit

protocol Section {
    var title: String { get }
    var image: UIImage { get }
    var indexs: [IndexEnum] { get }
    var tableViewCell: UITableViewCell.Type { get }
}

extension SectionEnum: Section {
    var title: String {
        switch self {
        case .hiraganakatagana:
            return "히라가나 가타카나 표"
        case .kanji:
            return "일본 상용한자"
        case .vocabulary:
            return "JLPT 단어장"
        }
    }
    
    var image: UIImage {
        switch self {
        case .hiraganakatagana:
            return UIImage(named: "hiraganakatakana.png")!
        case .kanji:
            return UIImage(named: "kanji.png")!
        case .vocabulary:
            return UIImage(named: "jlpt.png")!
        }
    }
    
    var indexs: [IndexEnum] {
        switch self {
        case .hiraganakatagana:
            return [
                .hiragana,
                .katakana,
            ]
        case .kanji:
            return [
                .bookmark,
                .elementary1,
                .elementary2,
                .elementary3,
                .elementary4,
                .elementary5,
                .elementary6,
                .middle,
            ]
        case .vocabulary:
            return [
                .bookmark,
                .n5,
                .n4,
                .n3,
                .n2,
                .n1,
            ]
        }
    }
    
    var tableViewCell: UITableViewCell.Type {
        switch self {
        case .hiraganakatagana:
            return UITableViewCell.self
        case .kanji:
            return KanjiTableViewCell.self
        case .vocabulary:
            return VocabularyTableViewCell.self
        }
    }
}
