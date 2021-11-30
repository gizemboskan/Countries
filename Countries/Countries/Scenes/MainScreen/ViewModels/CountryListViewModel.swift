//
//  CountryListViewModel.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol CountryListViewModelProtocol {
    var countryListDatasource: BehaviorRelay<[CountryModel]> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var onError: BehaviorRelay<Bool> { get set }
    var navigateToDetailReady: BehaviorRelay<(repository: CountryListRepository, code: String, isFav: Bool)?> { get set }
    var countryListRepository: CountryListRepository? { get set }
    
    func getCountryList()
    func navigateToDetail(code: String, isFav: Bool)
    func getCellViewModels(indexpath: IndexPath) -> CountryTableViewCellViewModel
}

final class CountryListViewModel: CountryListViewModelProtocol {
    // MARK: - Properties
    private var limit: Int = 10
    private var bag = DisposeBag()
    
    var countryListDatasource = BehaviorRelay<[CountryModel]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var onError = BehaviorRelay<Bool>(value: false)
    var navigateToDetailReady = BehaviorRelay<(repository: CountryListRepository, code: String, isFav: Bool)?>(value: nil)
    var countryListRepository: CountryListRepository?
    
    //MARK: - Public Methods
    func getCountryList() {
        guard let countryListRepository = countryListRepository else { return }
        
        countryListRepository.getCountryList(limit: limit)
        
        countryListRepository.countryListDatasource
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] countryListResponse in
                guard let self = self else { return }
                self.updateCountryListDatasource(with: countryListResponse)
            })
            .disposed(by: bag)
        
        countryListRepository.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                self.isLoading.accept(isLoading)
            })
            .disposed(by: bag)
        
        countryListRepository.onError
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] onError in
                guard let self = self else { return }
                self.onError.accept(onError)
            })
            .disposed(by: bag)
    }
    
    func navigateToDetail(code: String, isFav: Bool) {
        guard let countryListRepository = countryListRepository else { return }
        navigateToDetailReady.accept((repository: countryListRepository, code: code, isFav: isFav))
    }
    
    func getCellViewModels(indexpath: IndexPath) -> CountryTableViewCellViewModel {
        let cellVM = CountryTableViewCellViewModel(code: countryListDatasource.value[indexpath.row].code,
                                                   isFav: countryListDatasource.value[indexpath.row].isFav)
        cellVM.countryListRepository = self.countryListRepository
        return cellVM
    }
}

//MARK: - Helper Methods
extension CountryListViewModel {
    private func updateCountryListDatasource(with country: [CountryModel]) {
        self.countryListDatasource.accept(country)
    }
}
