//
//  SavedCountriesViewModel.swift
//  Countries
//
//  Created by Gizem Boskan on 27.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol SavedCountriesViewModelProtocol {
    var savedCountriesDatasource: BehaviorRelay<[Datum]> { get set }
    var savedCountryCodesDatasource: BehaviorRelay<[String]> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var onError: BehaviorRelay<Bool> { get set }
    var navigateToDetailReady: BehaviorRelay<CountryDetailViewModel?> { get set }
    var mainScreenApi: MainScreenApi? { get set }

    func navigateToDetail(code: String)
}

final class SavedCountriesViewModel: SavedCountriesViewModelProtocol {
    // MARK: - Properties
    private var bag = DisposeBag()
    
    var savedCountriesDatasource = BehaviorRelay<[Datum]>(value: [])
    var savedCountryCodesDatasource = BehaviorRelay<[String]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var onError = BehaviorRelay<Bool>(value: false)
    var navigateToDetailReady = BehaviorRelay<CountryDetailViewModel?>(value: nil)
    var mainScreenApi: MainScreenApi?
    
    // MARK: - Initilizations
    init() { }
    
    //MARK: - Public Methods
    func navigateToDetail(code: String) {
        let detailViewModel = CountryDetailViewModel()
        detailViewModel.countryCodeDatasource.accept(code)
        navigateToDetailReady.accept(detailViewModel)
    }
}

//MARK: - Helper Methods
extension SavedCountriesViewModel {
    
}
