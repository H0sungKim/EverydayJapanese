//
//  JSONReader.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/13/24.
//

import Foundation

struct Vocabulary: Codable {
    let word: String
    let sound: String
    let meaning: String
}

class JSONReader: NSObject {
    
    public static let shared = JSONReader()
    
    private override init() {
        super.init()
    }
    
    func readKanjiJSON(difficulty: Int) -> [Kanji] {
        guard let path = Bundle.main.path(forResource: "kanji\(difficulty)", ofType: "json") else {
            NSLog("Error, JSON file not found.")
            return []
        }
        do {
            let url = URL(fileURLWithPath: path)
            let jsonData = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            let kanjis = try decoder.decode([Kanji].self, from: jsonData)
            return kanjis
        } catch {
            NSLog("Error, decoding JSON")
            return []
        }
    }
    
//    func readJSON(
    
}
//        struct JapaneseWords: Codable {
//            let word: String
//            let sound: String
//            let meaning: String
//        }
//
//        let jsonData = """
//        [
//            { "word": "ロビー", "sound": "", "meaning": "명사 1.로비 2.넓은 휴게·담화용 홀 3.국회 등에서 의원이 원외 사람들과 만나는 데" },
//            { "word": "ロボット", "sound": "", "meaning": "명사 1.로봇 2.인조 인간 3.허수아비;괴뢰" }
//        ]
//        """.data(using: .utf8)!
//
//        do {
//            let decoder = JSONDecoder()
//            let japaneseWords = try decoder.decode([JapaneseWords].self, from: jsonData)
//
//            for word in japaneseWords {
//                print("Word: \(word.word)")
//                print("Sound: \(word.sound)")
//                print("Meaning: \(word.meaning)")
//                print("\n")
//            }
//        } catch {
//            print("Error decoding JSON: \(error)")
//        }
