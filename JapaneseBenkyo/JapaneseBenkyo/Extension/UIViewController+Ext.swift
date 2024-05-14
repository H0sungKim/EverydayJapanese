//
//  UIViewController+Util.swift
//  JapaneseBenkyo
//
//  Created by Hosung.Kim on 2021/11/22.
//

import UIKit

// MARK: - Public Outter Class, Struct, Enum, Protocol
enum ViewControllerEnum: String, CaseIterable {
    case vocabulary
    case vocabularyday
    case vocabularystudy
    case vocabularytest
    case vocabularytestresult
    
    case kanji
    case kanjiday
    case kanjistudy
    case kanjitest
    case kanjitestresult
}

extension UIViewController {

    // MARK: - Public Method
    class func getViewController(viewControllerEnum: ViewControllerEnum) -> UIViewController {
        switch viewControllerEnum {
        case .vocabulary:
            return getViewController(storyboard: "Vocabulary", identifier: String(describing: VocabularyViewController.self), modalPresentationStyle: .fullScreen)
        case .vocabularyday:
            return getViewController(storyboard: "VocabularyDay", identifier: String(describing: VocabularyDayViewController.self), modalPresentationStyle: .fullScreen)
        case .vocabularystudy:
            return getViewController(storyboard: "VocabularyStudy", identifier: String(describing: VocabularyStudyViewController.self), modalPresentationStyle: .fullScreen)
        case .vocabularytest:
            return getViewController(storyboard: "VocabularyTest", identifier: String(describing: VocabularyTestViewController.self), modalPresentationStyle: .fullScreen)
        case .vocabularytestresult:
            return getViewController(storyboard: "VocabularyTestResult", identifier: String(describing: VocabularyTestResultViewController.self), modalPresentationStyle: .fullScreen)
            
        case .kanji:
            return getViewController(storyboard: "Kanji", identifier: String(describing: KanjiViewController.self), modalPresentationStyle: .fullScreen)
        case .kanjiday:
            return getViewController(storyboard: "KanjiDay", identifier: String(describing: KanjiDayViewController.self), modalPresentationStyle: .fullScreen)
        case .kanjistudy:
            return getViewController(storyboard: "KanjiStudy", identifier: String(describing: KanjiStudyViewController.self), modalPresentationStyle: .fullScreen)
        case .kanjitest:
            return getViewController(storyboard: "KanjiTest", identifier: String(describing: KanjiTestViewController.self), modalPresentationStyle: .fullScreen)
        case .kanjitestresult:
            return getViewController(storyboard: "KanjiTestResult", identifier: String(describing: KanjiTestResultViewController.self), modalPresentationStyle: .fullScreen)
        }
    }
    class func getViewController(catalogueEnum: CatalogueEnum) -> UIViewController {
        switch catalogueEnum {
        case .vocabulary:
            return getViewController(viewControllerEnum: .vocabulary)
        case .kanji:
            return getViewController(viewControllerEnum: .kanji)
        }
    }
    
    // MARK: - Private Method
    private class func getViewController(storyboard: String, identifier: String, modalPresentationStyle: UIModalPresentationStyle) -> UIViewController {
        let sb = UIStoryboard(name: storyboard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: identifier)
        vc.modalPresentationStyle = modalPresentationStyle
        return vc
    }
}
