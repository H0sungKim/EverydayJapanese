//
//  UIViewController+Util.swift
//  IOSSample
//
//  Created by Hosung.Kim on 2021/11/22.
//

import UIKit

// MARK: - Public Outter Class, Struct, Enum, Protocol
enum ViewControllerEnum: String, CaseIterable {
//    case JLPTBookmark = "JLPT 즐겨찾기"
//    case JLPT5 = "JLPT5"
//    case JLPT4 = "JLPT4"
//    case JLPT3 = "JLPT3"
//    case JLPT2 = "JLPT2"
//    case JLPT1 = "JLPT1"
//    
//    case kanjiBookmark = "漢字 かんじ 즐겨찾기"
//    case kanji0 = "漢字 かんじ 소학교 1학년"
//    case kanji1 = "漢字 かんじ 소학교 2학년"
//    case kanji2 = "漢字 かんじ 소학교 3학년"
//    case kanji3 = "漢字 かんじ 소학교 4학년"
//    case kanji4 = "漢字 かんじ 소학교 5학년"
//    case kanji5 = "漢字 かんじ 소학교 6학년"
//    case kanji6 = "漢字 かんじ 중학교"
    case vocabulary
    case kanji
    case kanjistudy
}

extension UIViewController {

    // MARK: - Public Method
    class func getViewController(viewControllerEnum: ViewControllerEnum) -> UIViewController {
        switch viewControllerEnum {
        case .vocabulary:
            return getViewController(storyboard: "Vocabulary", identifier: String(describing: VocabularyViewController.self), modalPresentationStyle: .fullScreen)
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
