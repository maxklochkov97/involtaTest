//
//  AppDelegate.swift
//  involtaTest
//
//  Created by Максим Клочков on 06.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MessageViewController()
        window?.makeKeyAndVisible()

        return true
    }
}
