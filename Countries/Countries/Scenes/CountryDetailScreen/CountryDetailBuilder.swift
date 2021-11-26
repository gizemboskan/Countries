//
//  CountryDetailBuilder.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation
import UIKit

final class CountryDetailBuilder {
    
    static func make(with viewModel: CountryDetailViewModel) -> CountryDetailViewController {
        let storyboard = UIStoryboard(name: "CountryDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "CountryDetailViewController") as! CountryDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }
}
