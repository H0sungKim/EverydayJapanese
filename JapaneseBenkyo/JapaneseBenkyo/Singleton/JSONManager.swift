//
//  JSONReader.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/13/24.
//

import Foundation

class JSONManager: NSObject {
    
    public static let shared = JSONManager()
    
    private override init() {
        super.init()
    }

    func encodeVocabularyJSON(vocabularies: Set<Vocabulary>) -> String {
        let encoded = try? JSONEncoder().encode(vocabularies)
        return String(decoding: encoded!, as: UTF8.self)
    }
    
    func decodeJSONtoVocabularyArray(jsonData: Data) -> [Vocabulary] {
        if let vocabularies = try? JSONDecoder().decode([Vocabulary].self, from: jsonData) {
            return vocabularies
        }
        return []
    }
    
    func decodeJSONtoVocabularySet(jsonData: Data) -> Set<Vocabulary> {
        if let vocabularies = try? JSONDecoder().decode(Set<Vocabulary>.self, from: jsonData) {
            return vocabularies
        }
        return []
    }
    
    
    func encodeKanjiJSON(kanjis: Set<Kanji>) -> String {
        let encoded = try? JSONEncoder().encode(kanjis)
        return String(decoding: encoded!, as: UTF8.self)
    }
    
    func decodeJSONtoKanjiArray(jsonData: Data) -> [Kanji] {
        if let kanjis = try? JSONDecoder().decode([Kanji].self, from: jsonData) {
            return kanjis
        }
        return []
    }
    
    func decodeJSONtoKanjiSet(jsonData: Data) -> Set<Kanji> {
        if let kanjis = try? JSONDecoder().decode(Set<Kanji>.self, from: jsonData) {
            return kanjis
        }
        return []
    }
    
    
    func openJSON(path: String) -> Data? {
        guard let path = Bundle.main.path(forResource: path, ofType: "json") else {
            NSLog("Error, JSON file not found.")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        if let jsonData = try? Data(contentsOf: url) {
            return jsonData
        } else {
            return nil
        }
    }
    
    func convertStringToData(jsonString: String) -> Data? {
        return jsonString.data(using: .utf8)
    }
}
