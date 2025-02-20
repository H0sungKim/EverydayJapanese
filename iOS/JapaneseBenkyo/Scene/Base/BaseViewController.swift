//
//  BaseViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.02.06.
//

import UIKit
import AppTrackingTransparency

class BaseViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    private var containerViewController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerViewController()
    }
    
    private func setupContainerViewController() {
        containerViewController = UINavigationController(rootViewController: UIViewController.getViewController(viewControllerEnum: .main))
        guard let containerViewController = containerViewController else { return }
        containerViewController.setNavigationBarHidden(true, animated: false)
        containerViewController.interactivePopGestureRecognizer?.isEnabled = true
        containerViewController.interactivePopGestureRecognizer?.delegate = self
        addChild(containerViewController)
        containerViewController.view.frame = containerView.bounds
        containerView.addSubview(containerViewController.view)
        containerViewController.didMove(toParent: self)
    }
    
//    private func loadAd() {
//        if #available(iOS 14, *) {
//            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
//                self?.bannerView.loadAd()
//            }
//        } else {
//            self.bannerView.loadAd()
//        }
//    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    // Prevent the rootviewcontroller from being popped.
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return containerViewController?.viewControllers.count ?? 0 > 1
    }
}
