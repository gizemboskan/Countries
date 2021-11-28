//
//  SavedCountriesBuilder.swift
//  Countries
//
//  Created by Gizem Boskan on 27.11.2021.
//

import Foundation
import UIKit

final class SavedCountriesBuilder {
    static func make(repository: MainScreenApiProtocol) -> SavedCountriesViewController {
        let storyboard = UIStoryboard(name: "SavedCountries", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "SavedCountriesViewController") as! SavedCountriesViewController
        var viewModel: SavedCountriesViewModelProtocol = SavedCountriesViewModel()
        viewModel.mainScreenApi = repository
        viewController.viewModel = viewModel
        return viewController
    }
}
