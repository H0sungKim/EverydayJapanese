//
//  UserDefaultManager.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/13/24.
//

import Foundation

private enum UserDefaultEnum: String {
    case vocabularyBookmark
    case kanjiBookmark
}

class UserDefaultManager {
    
    public static let shared = UserDefaultManager()
    
    private init() {
    }
    
    var vocabularyBookmark: [Vocabulary]? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaultEnum.vocabularyBookmark.rawValue) as? [Vocabulary]
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultEnum.vocabularyBookmark.rawValue)
        }
    }
    
    var kanjiBookmark: [Kanji]? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaultEnum.kanjiBookmark.rawValue) as? [Kanji]
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultEnum.kanjiBookmark.rawValue)
        }
    }
    
}
