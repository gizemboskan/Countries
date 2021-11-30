//
//  AppRouter.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit

final class AppRouter {
    
    func start(window: UIWindow) {
        let tabBarViewController = MainScreenBuilder.make()
        window.rootViewController = tabBarViewController
        window.makeKeyAndVisible()
    }
}
