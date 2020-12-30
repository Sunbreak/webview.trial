//
//  AppDelegate.swift
//  ios_webview
//
//  Created by sunbreak on 2020/12/29.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds).apply {
            $0.rootViewController = UINavigationController().apply { nav in
                nav.viewControllers = [ViewController()]
            }
            $0.makeKeyAndVisible()
        }
        return true
    }
}
