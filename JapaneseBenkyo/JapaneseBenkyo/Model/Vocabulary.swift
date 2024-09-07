//
//  Vocabulary.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/15/24.
//

import Foundation

struct Vocabulary: Codable, Equatable, Hashable {
    let word: String
    let sound: String
    let meaning: String
}

class VocabularyForCell {
    let vocabulary: Vocabulary
    var isVisible: Bool = false
    var isBookmark: Bool = false
    
    init(vocabulary: Vocabulary) {
        self.vocabulary = vocabulary
    }
}
