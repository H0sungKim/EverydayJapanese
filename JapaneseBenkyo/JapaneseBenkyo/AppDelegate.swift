//
//  AppDelegate.swift
//  JapaneseBenkyo
//
//  Created by 김호성 on 2/12/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(1)
        // 1. 화면 해상도를 얻어온다.
        let screen = UIScreen.main
        let bounds = screen.bounds
        
        // 2. 윈도우 생성
        self.window = UIWindow(frame: bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            
            // 3. 윈도우의 뷰 컨트롤러 지정
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
            let navigationController =  UINavigationController.init(rootViewController:viewController)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        
        return true
    }
}

