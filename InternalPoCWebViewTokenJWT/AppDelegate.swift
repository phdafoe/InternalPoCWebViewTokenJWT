//
//  AppDelegate.swift
//  InternalPoCWebViewTokenJWT
//
//  Created by TECDATA ENGINEERING on 29/3/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appCore: AppInitProtocol = AppInit()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let windowUnw = self.window else { return false }
        self.appCore.initApp(window: windowUnw)
        return true
    }

}

