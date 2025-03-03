//
//  UserDefaultManager.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/13/24.
//

import Foundation

private enum UserDefaultEnum: String {
    case bookmarkVoca
    case bookmarkKanji
    case passVoca
    case passKanji
    
    // deprecated
    case process
    case vocabularyBookmark
    case kanjiBookmark
}

class UserDefaultManager {
    
    public static let shared = UserDefaultManager()
    
    private init() {
        
    }
    
    var bookmarkVoca: Set<String> {
        get {
            return Set(UserDefaults.standard.stringArray(forKey: UserDefaultEnum.bookmarkVoca.rawValue) ?? [])
        }
        set {
            UserDefaults.standard.setValue(Array(newValue), forKey: UserDefaultEnum.bookmarkVoca.rawValue)
        }
    }
    var bookmarkKanji: Set<String> {
        get {
            return Set(UserDefaults.standard.stringArray(forKey: UserDefaultEnum.bookmarkKanji.rawValue) ?? [])
        }
        set {
            UserDefaults.standard.setValue(Array(newValue), forKey: UserDefaultEnum.bookmarkKanji.rawValue)
        }
    }
    var passVoca: Set<String> {
        get {
            return Set(UserDefaults.standard.stringArray(forKey: UserDefaultEnum.passVoca.rawValue) ?? [])
        }
        set {
            UserDefaults.standard.setValue(Array(newValue), forKey: UserDefaultEnum.passVoca.rawValue)
        }
    }
    var passKanji: Set<String> {
        get {
            return Set(UserDefaults.standard.stringArray(forKey: UserDefaultEnum.passKanji.rawValue) ?? [])
        }
        set {
            UserDefaults.standard.setValue(Array(newValue), forKey: UserDefaultEnum.passKanji.rawValue)
        }
    }
    
    // deprecated
    var oldProcess: String {
        get {
            return UserDefaults.standard.value(forKey: UserDefaultEnum.process.rawValue) as? String ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultEnum.process.rawValue)
        }
    }
    
    var oldVocabularyBookmark: String {
        get {
            return UserDefaults.standard.value(forKey: UserDefaultEnum.vocabularyBookmark.rawValue) as? String ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultEnum.vocabularyBookmark.rawValue)
        }
    }
    
    var oldKanjiBookmark: String {
        get {
            return UserDefaults.standard.value(forKey: UserDefaultEnum.kanjiBookmark.rawValue) as? String ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultEnum.kanjiBookmark.rawValue)
        }
    }
    
    func clearOld() {
        UserDefaults.standard.removeObject(forKey: UserDefaultEnum.process.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultEnum.vocabularyBookmark.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultEnum.kanjiBookmark.rawValue)
    }
    
    func clearAll() {
        UserDefaults.standard.removeObject(forKey: UserDefaultEnum.bookmarkVoca.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultEnum.bookmarkKanji.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultEnum.passVoca.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultEnum.passKanji.rawValue)
    }
}
