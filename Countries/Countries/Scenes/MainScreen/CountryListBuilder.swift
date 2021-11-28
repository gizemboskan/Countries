//
//  CountryListBuilder.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit

final class CountryListBuilder {
    
    static func make(repository: MainScreenApiProtocol) -> CountryListViewController {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "CountryListViewController") as! CountryListViewController
        var viewModel: CountryListViewModelProtocol = CountryListViewModel()
        viewModel.mainScreenApi = repository
        viewController.viewModel = viewModel
        return viewController
    }
}
