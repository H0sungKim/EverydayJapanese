//
//  BaseViewController.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2025.02.06.
//

import UIKit
import AppTrackingTransparency
import AdFitSDK

class BaseViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    var bannerView: AdFitBannerAdView!
    
    private var containerViewController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerViewController()
        guard let adMyKey = Bundle.main.adMyKey else { return }
        bannerView = AdFitBannerAdView(clientId: adMyKey, adUnitSize: "320x50")
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        loadAd()
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
    
    private func loadAd() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                self?.bannerView.loadAd()
            }
        } else {
            self.bannerView.loadAd()
        }
    }
}

extension BaseViewController: AdFitBannerAdViewDelegate {
    //Mark - AdFitBannerAdViewDelegate
    func adViewDidReceiveAd(_ bannerAdView: AdFitBannerAdView) {
        print("didReceiveAd")
    }
    
    func adViewDidFailToReceiveAd(_ bannerAdView: AdFitBannerAdView, error: Error) {
        print("didFailToReceive - error :\(error.localizedDescription)" )
    }
    
    func adViewDidClickAd(_ bannerAdView: AdFitBannerAdView) {
        print("didClickAd")
    }
}

extension BaseViewController: UIGestureRecognizerDelegate {
    // Prevent the rootviewcontroller from being popped.
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return containerViewController?.viewControllers.count ?? 0 > 1
    }
}
