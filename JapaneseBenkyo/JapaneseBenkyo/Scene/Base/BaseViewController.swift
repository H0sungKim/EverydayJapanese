//
//  BaseViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.02.06.
//

import UIKit
import GoogleMobileAds

class BaseViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerChildViewController = UINavigationController(rootViewController: UIViewController.getViewController(viewControllerEnum: .main))
        containerChildViewController.setNavigationBarHidden(true, animated: false)
        containerChildViewController.interactivePopGestureRecognizer?.isEnabled = true
        containerChildViewController.interactivePopGestureRecognizer?.delegate = self
        addChild(containerChildViewController)
        containerChildViewController.view.frame = containerView.bounds
        containerView.addSubview(containerChildViewController.view)
        containerChildViewController.didMove(toParent: self)
#if DEBUG
        bannerView.adUnitID = Bundle.main.adTestKey
#else
        bannerView.adUnitID = Bundle.main.adMyKey
#endif
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    // Prevent the rootviewcontroller from being popped.
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController?.viewControllers.count ?? 0 > 1
    }
}
