//
//  AppDelegate.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/12/24.
//

import UIKit
import AVFoundation
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // For splash launchscreen.
        sleep(1)
        
        let screen = UIScreen.main
        let bounds = screen.bounds
        
        self.window = UIWindow(frame: bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            
            let viewController = UIViewController.getViewController(viewControllerEnum: .base)
            
            window.rootViewController = viewController
            window.makeKeyAndVisible()
            
            // Without this block, music will stop when you play TTS.
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error as NSError {
                print("Error : \(error), \(error.userInfo)")
            }
        }
        
        // Temp =============================================
        
        // Bookmark
        let kanjiBookmark: Set<Kanji> = JSONManager.shared.decode(data: UserDefaultManager.shared.oldKanjiBookmark.data(using: .utf8) ?? Data(), type: Set<Kanji>.self) ?? []
        let vocabularyBookmark: Set<Vocabulary> = JSONManager.shared.decode(data: UserDefaultManager.shared.oldVocabularyBookmark.data(using: .utf8) ?? Data(), type: Set<Vocabulary>.self) ?? []
        print(kanjiBookmark)
        print(vocabularyBookmark)
        // process
        let process = JSONManager.shared.decode(data: UserDefaultManager.shared.oldProcess.data(using: .utf8) ?? Data(), type: [String: [String: Bool]].self) ?? [:]
        print(process)
        if !(kanjiBookmark.isEmpty && vocabularyBookmark.isEmpty && process.isEmpty) {
            print("***************************")
            let kanjiEnums: [IndexEnum] = [
                .elementary1,
                .elementary2,
                .elementary3,
                .elementary4,
                .elementary5,
                .elementary6,
                .middle,
            ]
            let kanjis = GlobalDataManager.shared.kanjis
            
            var newKanjiBookmark: Set<String> = UserDefaultManager.shared.bookmarkKanji
            for key in kanjis.keys {
                guard let kanji = kanjis[key] else { continue }
                if kanjiBookmark.contains(kanji) {
                    newKanjiBookmark.insert(key)
                }
            }
            print(newKanjiBookmark)
            UserDefaultManager.shared.bookmarkKanji = newKanjiBookmark
            
            for kanjiEnum in kanjiEnums {
                var processId: Set<String> = UserDefaultManager.shared.passKanji
                let levelProcess: [String: Bool] = process[kanjiEnum.rawValue] ?? [:]
                for key in levelProcess.keys {
                    switch key {
                    case "전체보기":
                        processId.formUnion(kanjiEnum.idRange.map({ String($0) }))
                    default:
                        guard key.hasPrefix("Day"), let day = Int(key.dropFirst(3)) else { break }
                        processId.formUnion(((kanjiEnum.idRange.lowerBound + (day - 1) * 20)..<(min(kanjiEnum.idRange.lowerBound + day * 20, kanjiEnum.idRange.upperBound))).map({ String($0) }))
                    }
                }
                print(processId)
                UserDefaultManager.shared.passKanji = processId
            }
            
            let vocabularyEnums: [IndexEnum] = [
                .n5,
                .n4,
                .n3,
                .n2,
                .n1,
            ]
            let vocabularies: [String: Vocabulary] = {
                guard let jsonData = JSONManager.shared.openJSON(path: SectionEnum.vocabulary.fileName) else { return [:] }
                return JSONManager.shared.decode(data: jsonData, type: [String: Vocabulary].self) ?? [:]
            }()
            var newVocaBookmark: Set<String> = UserDefaultManager.shared.bookmarkVoca
            for key in vocabularies.keys {
                guard let voca = vocabularies[key] else { continue }
                if vocabularyBookmark.contains(voca) {
                    newVocaBookmark.insert(key)
                }
            }
            print(newVocaBookmark)
            UserDefaultManager.shared.bookmarkVoca = newVocaBookmark
            
            for vocabularyEnum in vocabularyEnums {
                var processId: Set<String> = UserDefaultManager.shared.passVoca
                let levelProcess: [String: Bool] = process[vocabularyEnum.rawValue] ?? [:]
                for key in levelProcess.keys {
                    switch key {
                    case "전체보기":
                        processId.formUnion(vocabularyEnum.idRange.map({ String($0) }))
                    default:
                        guard key.hasPrefix("Day"), let day = Int(key.dropFirst(3)) else { break }
                        processId.formUnion(((vocabularyEnum.idRange.lowerBound + (day - 1) * 20)..<(min(vocabularyEnum.idRange.lowerBound + day * 20, vocabularyEnum.idRange.upperBound))).map({ String($0) }))
                    }
                }
                UserDefaultManager.shared.passVoca = processId
                print(processId)
            }
            
            UserDefaultManager.shared.clearOld()
        }
        print(UserDefaultManager.shared.bookmarkVoca)
        print(UserDefaultManager.shared.bookmarkKanji)
        print(UserDefaultManager.shared.passVoca)
        print(UserDefaultManager.shared.passKanji)
        if !(UserDefaultManager.shared.bookmarkVoca.isEmpty && UserDefaultManager.shared.bookmarkKanji.isEmpty && UserDefaultManager.shared.passVoca.isEmpty && UserDefaultManager.shared.passKanji.isEmpty) {
            GroupedUserDefaultsManager.shared.bookmarkVoca = UserDefaultManager.shared.bookmarkVoca
            GroupedUserDefaultsManager.shared.bookmarkKanji = UserDefaultManager.shared.bookmarkKanji
            GroupedUserDefaultsManager.shared.passVoca = UserDefaultManager.shared.passVoca
            GroupedUserDefaultsManager.shared.passKanji = UserDefaultManager.shared.passKanji
            
            UserDefaultManager.shared.clearAll()
        }
        
        // Temp =============================================
        return true
    }
    
    // Hold the screen vertically.
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
                
            })
        }
    }
}
