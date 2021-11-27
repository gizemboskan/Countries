//
//  AppRouter.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit

final class AppRouter {
    
    func start(window: UIWindow) {
        let firstViewController = CountryListBuilder.make()
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)
        let firstTabBarItem = UITabBarItem(title: "Home",  image: UIImage(systemName: "house.fill")?.withTintColor(.black), selectedImage: UIImage(systemName: "house.fill")?.withTintColor(.white))
        firstNavigationController.tabBarItem = firstTabBarItem
        
        let secondViewController = SavedCountriesBuilder.make()
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        let secondTabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "heart.fill")?.withTintColor(.black), selectedImage: UIImage(systemName: "heart.fill")?.withTintColor(.white))
        secondNavigationController.tabBarItem = secondTabBarItem
        
        let tabBarViewController = MainScreenBuilder.make()
        tabBarViewController.setViewControllers([firstNavigationController, secondNavigationController], animated: true)
        window.rootViewController = tabBarViewController
        window.makeKeyAndVisible()
    }
}
