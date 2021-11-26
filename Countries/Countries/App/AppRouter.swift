//
//  AppRouter.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit

final class AppRouter {
    
    func start(window: UIWindow) {
        let viewController = CountryListBuilder.make(with: CountryListViewModel())
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
