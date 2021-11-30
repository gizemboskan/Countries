//
//  MainScreenBuilder.swift
//  Countries
//
//  Created by Gizem Boskan on 27.11.2021.
//

import UIKit

final class MainScreenBuilder {
    
    static func make() -> UITabBarController {
        
        let repository: CountryListRepository = CountryListRepositoryImplementation()
        let firstViewController = CountryListBuilder.make(repository: repository)
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)
        let firstTabBarItem = UITabBarItem(title: "Home",  image: UIImage(systemName: "house.fill")?.withTintColor(.black), selectedImage: UIImage(systemName: "house.fill")?.withTintColor(.white))
        firstNavigationController.tabBarItem = firstTabBarItem
        
        let secondViewController = SavedCountriesBuilder.make(repository: repository)
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        let secondTabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "heart.fill")?.withTintColor(.black), selectedImage: UIImage(systemName: "heart.fill")?.withTintColor(.white))
        secondNavigationController.tabBarItem = secondTabBarItem
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "TabBarViewController") as! UITabBarController
        viewController.setViewControllers([firstNavigationController, secondNavigationController], animated: true)
        return viewController
    }
}
