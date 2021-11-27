//
//  CountryListBuilder.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit

final class CountryListBuilder {
    
    static func make() -> CountryListViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "CountryListViewController") as! CountryListViewController
        var viewModel: CountryListViewModelProtocol = CountryListViewModel()
        let api: MainScreenApi = MainScreenApiImplementation()
        viewModel.mainScreenApi = api
        viewController.viewModel = viewModel
        return viewController
    }
}
