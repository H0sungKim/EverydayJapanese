//
//  UIViewController+Util.swift
//  IOSSample
//
//  Created by Hosung.Kim on 2021/11/22.
//

import UIKit

// MARK: - Public Outter Class, Struct, Enum, Protocol
enum ViewControllerEnum: String, CaseIterable {
    case vocabulary
    case vocabularyday
    case vocabularystudy
    case kanji
    case kanjistudy
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
        case .kanji:
            return getViewController(storyboard: "Kanji", identifier: String(describing: KanjiViewController.self), modalPresentationStyle: .fullScreen)
        case .kanjistudy:
            return getViewController(storyboard: "KanjiStudy", identifier: String(describing: KanjiStudyViewController.self), modalPresentationStyle: .fullScreen)
        }
    }
    class func getViewController(subjectEnum: SubjectEnum) -> UIViewController {
        switch subjectEnum {
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
