//
//  UIViewController+Util.swift
//  JapaneseBenkyo
//
//  Created by Hosung.Kim on 2021/11/22.
//

import UIKit

// MARK: - Public Outter Class, Struct, Enum, Protocol
enum ViewControllerEnum: String, CaseIterable {
    
    case day
    case study
    case test
    case testresult
}

extension UIViewController {

    // MARK: - Public Method
    class func getViewController(viewControllerEnum: ViewControllerEnum) -> UIViewController {
        switch viewControllerEnum {
            
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
