//
//  CountryDetailBuilder.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation
import UIKit

final class CountryDetailBuilder {
    
    static func make(repository: CountryListRepository, code: String, isFav: Bool) -> CountryDetailViewController {
        let storyboard = UIStoryboard(name: "CountryDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "CountryDetailViewController") as! CountryDetailViewController
        var viewModel: CountryDetailViewModelProtocol = CountryDetailViewModel(code: code, isFav: isFav)
        viewModel.countryDetailApi = CountryDetailApiImplementation()
        viewModel.countryListRepository = repository
        viewController.viewModel = viewModel
        return viewController
    }
}
