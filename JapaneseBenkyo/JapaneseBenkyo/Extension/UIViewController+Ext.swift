//
//  UIViewController+Util.swift
//  JapaneseBenkyo
//
//  Created by Hosung.Kim on 2021/11/22.
//

import UIKit

// MARK: - Public Outter Class, Struct, Enum, Protocol
enum ViewControllerEnum: String, CaseIterable {
    case hiraganakatakana
    case hiraganakatakanatest
    case hiraganakatakanatestresult
    case day
    case study
    case test
    case testresult
}

extension UIViewController {

    // MARK: - Public Method
    class func getViewController(viewControllerEnum: ViewControllerEnum) -> UIViewController {
        switch viewControllerEnum {
        case .hiraganakatakana:
            return getViewController(storyboard: "HiraganaKatakana", identifier: String(describing: HiraganaKatakanaViewController.self), modalPresentationStyle: .fullScreen)
        case .hiraganakatakanatest:
            return getViewController(storyboard: "HiraganaKatakanaTest", identifier: String(describing: HiraganaKatakanaTestViewController.self), modalPresentationStyle: .fullScreen)
        case .hiraganakatakanatestresult:
            return getViewController(storyboard: "HiraganaKatakanaTestResult", identifier: String(describing: HiraganaKatakanaTestResultViewController.self), modalPresentationStyle: .fullScreen)
        case .day:
            return getViewController(storyboard: "Day", identifier: String(describing: DayViewController.self), modalPresentationStyle: .fullScreen)
        case .study:
            return getViewController(storyboard: "Study", identifier: String(describing: StudyViewController.self), modalPresentationStyle: .fullScreen)
        case .test:
            return getViewController(storyboard: "Test", identifier: String(describing: TestViewController.self), modalPresentationStyle: .fullScreen)
        case .testresult:
            return getViewController(storyboard: "TestResult", identifier: String(describing: TestResultViewController.self), modalPresentationStyle: .fullScreen)
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
