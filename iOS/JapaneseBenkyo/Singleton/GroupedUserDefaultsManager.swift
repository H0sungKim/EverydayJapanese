//
//  GroupedUserDefaultsManager.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.03.03.
//

import Foundation

private enum GroupedUserDefaultsEnum: String {
    case bookmarkVoca
    case bookmarkKanji
    case passVoca
    case passKanji
}

class GroupedUserDefaultsManager {
    static let shared = GroupedUserDefaultsManager()
    
    private init() { }
    
    var bookmarkVoca: Set<String> {
        get {
            return Set(UserDefaults.grouped.stringArray(forKey: GroupedUserDefaultsEnum.bookmarkVoca.rawValue) ?? [])
        }
        set {
            UserDefaults.grouped.setValue(Array(newValue), forKey: GroupedUserDefaultsEnum.bookmarkVoca.rawValue)
        }
    }
    var bookmarkKanji: Set<String> {
        get {
            return Set(UserDefaults.grouped.stringArray(forKey: GroupedUserDefaultsEnum.bookmarkKanji.rawValue) ?? [])
        }
        set {
            UserDefaults.grouped.setValue(Array(newValue), forKey: GroupedUserDefaultsEnum.bookmarkKanji.rawValue)
        }
    }
    var passVoca: Set<String> {
        get {
            return Set(UserDefaults.grouped.stringArray(forKey: GroupedUserDefaultsEnum.passVoca.rawValue) ?? [])
        }
        set {
            UserDefaults.grouped.setValue(Array(newValue), forKey: GroupedUserDefaultsEnum.passVoca.rawValue)
        }
    }
    var passKanji: Set<String> {
        get {
            return Set(UserDefaults.grouped.stringArray(forKey: GroupedUserDefaultsEnum.passKanji.rawValue) ?? [])
        }
        set {
            UserDefaults.grouped.setValue(Array(newValue), forKey: GroupedUserDefaultsEnum.passKanji.rawValue)
        }
    }
}
