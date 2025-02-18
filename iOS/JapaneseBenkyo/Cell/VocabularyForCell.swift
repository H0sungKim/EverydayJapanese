//
//  VocabularyForCell.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2024.12.14.
//

import Foundation

class VocabularyForCell {
    let id: String
    let vocabulary: Vocabulary
    var isVisible: Bool = false
    var isBookmark: Bool = false
    var isExpanded: Bool = false
    var exampleSentence: TatoebaModel?
    
    init(id: String, vocabulary: Vocabulary, isBookmark: Bool) {
        self.id = id
        self.vocabulary = vocabulary
        self.isBookmark = isBookmark
    }
}
