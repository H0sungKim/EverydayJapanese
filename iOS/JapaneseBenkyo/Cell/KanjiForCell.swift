//
//  KanjiForCell.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.12.14.
//

import Foundation

class KanjiForCell {
    let id: String
    let kanji: Kanji
    var isVisible: Bool = false
    var isVisibleHanja: Bool = false
    var isBookmark: Bool = false
    var isExpanded: Bool = false
    
    init(id: String, kanji: Kanji, isBookmark: Bool) {
        self.id = id
        self.kanji = kanji
        self.isBookmark = isBookmark
    }
}
