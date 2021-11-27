//
//  MainScreenBuilder.swift
//  Countries
//
//  Created by Gizem Boskan on 27.11.2021.
//

import UIKit
final class MainScreenBuilder {
    
    static func make() -> TabBarViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "TabBarViewController") as! TabBarViewController
        var viewModel: TabBarViewModelProtocol = TabBarViewModel()
        
        viewController.viewModel = viewModel
        return viewController
    }
}
