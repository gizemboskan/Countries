//
//  SavedCountriesViewModel.swift
//  Countries
//
//  Created by Gizem Boskan on 27.11.2021.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import CoreData

protocol SavedCountriesViewModelProtocol {
    
    var savedCountryListDatasource: BehaviorRelay<[CountryModel]> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var onError: BehaviorRelay<Bool> { get set }
    var navigateToDetailReady: BehaviorRelay<(repository: MainScreenApiProtocol, code: String, isFav: Bool)?> { get set }
    var mainScreenApi: MainScreenApiProtocol? { get set }
    
    func getSavedCountryList()
    func navigateToDetail(code: String, isFav: Bool)
    func getCellViewModels(indexpath: IndexPath) -> CountryTableViewCellViewModel
}

final class SavedCountriesViewModel: SavedCountriesViewModelProtocol {
    // MARK: - Properties
    private var bag = DisposeBag()
    var savedCountryListDatasource = BehaviorRelay<[CountryModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var onError = BehaviorRelay<Bool>(value: false)
    var navigateToDetailReady = BehaviorRelay<(repository: MainScreenApiProtocol, code: String, isFav: Bool)?>(value: nil)
    var mainScreenApi: MainScreenApiProtocol?
    
    // MARK: - Initilizations
    init() { }
    
    //MARK: - Public Methods
    func getSavedCountryList() {
        guard let mainScreenApi = mainScreenApi else { return }
        
        mainScreenApi.countryListDatasource
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] countryListResponse in
                guard let self = self else { return }
                self.updateSavedCountryListDatasource(with: countryListResponse.filter { $0.isFav })
            })
            .disposed(by: bag)
        
        mainScreenApi.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.isLoading.accept(isLoading)
            })
            .disposed(by: bag)
        
        mainScreenApi.onError
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] onError in
                guard let self = self else { return }
                self.onError.accept(onError)
            })
            .disposed(by: bag)
    }
    
    func navigateToDetail(code: String, isFav: Bool) {
        guard let mainScreenApi = mainScreenApi else { return }
        navigateToDetailReady.accept((repository: mainScreenApi, code: code, isFav: isFav))
    }
    
    func getCellViewModels(indexpath: IndexPath) -> CountryTableViewCellViewModel {
        let cellVM = CountryTableViewCellViewModel(code: savedCountryListDatasource.value[indexpath.row].code,
                                                   isFav: savedCountryListDatasource.value[indexpath.row].isFav)
        cellVM.mainScreenApi = self.mainScreenApi
        return cellVM
    }
}


//MARK: - Helper Methods
extension SavedCountriesViewModel {
    private func updateSavedCountryListDatasource(with country: [CountryModel]) {
        self.savedCountryListDatasource.accept(country)
    }
}
