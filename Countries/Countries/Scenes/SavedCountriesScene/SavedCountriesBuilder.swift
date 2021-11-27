//
//  SavedCountriesBuilder.swift
//  Countries
//
//  Created by Gizem Boskan on 27.11.2021.
//

import Foundation
import UIKit

final class SavedCountriesBuilder {
    
    static func make() -> SavedCountriesViewController {
        let storyboard = UIStoryboard(name: "SavedCountries", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "SavedCountriesViewController") as! SavedCountriesViewController
        var viewModel: SavedCountriesViewModelProtocol = SavedCountriesViewModel()
        let api: MainScreenApi = MainScreenApiImplementation()
        viewModel.mainScreenApi = api
        viewController.viewModel = viewModel
        return viewController
    }
}
