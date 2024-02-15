//
//  Kanji.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/14/24.
//

import Foundation

struct Kanji: Codable, Equatable, Hashable {
    let kanji: String
    let hanja: String
    let eumhun: String
    let jpSound: String
    let jpMeaning: String
}

class KanjiForCell {
    let kanji: Kanji
    var isVisibleHanja: Bool = false
    var isVisibleEumhun: Bool = false
    var isVisibleJpSound: Bool = false
    var isVisibleJpMeaning: Bool = false
    var isBookmark: Bool = false
    
    init(kanji: Kanji) {
        self.kanji = kanji
        
    }
}
