//
//  GlobalDataManager.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.02.18.
//

import Foundation

class GlobalDataManager {
    
    public static let shared = GlobalDataManager()
    
    private init() {
        vocabularies = JSONManager.shared.decode(data: JSONManager.shared.openJSON(path: SectionEnum.vocabulary.fileName), type: [String: Vocabulary].self) ?? [:]
        kanjis = JSONManager.shared.decode(data: JSONManager.shared.openJSON(path: SectionEnum.kanji.fileName), type: [String: Kanji].self) ?? [:]
    }
    
    var vocabularies: [String: Vocabulary]
    var kanjis: [String: Kanji]
    
    func getCount(section: SectionEnum) -> Int {
        switch section {
        case .hiraganakatagana:
            return 0
        case .kanji:
            return kanjis.count
        case .vocabulary:
            return vocabularies.count
        }
    }
}
