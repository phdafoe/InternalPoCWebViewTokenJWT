//
//  AppInit.swift
//  InternalPoCWebViewTokenJWT
//
//  Created by TECDATA ENGINEERING on 29/3/23.
//

import Foundation
import UIKit

protocol AppInitProtocol {
    func initApp(window: UIWindow)
}

class AppInit: AppInitProtocol {
    
    var currentVC = UIViewController()
    
    func initApp(window: UIWindow) {
        self.currentVC = ArranqueViewCoordinator.view()
        window.rootViewController = self.currentVC
        window.makeKeyAndVisible()
    }
}
