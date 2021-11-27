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
    var countryListDatasource: BehaviorRelay<[Datum]> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var onError: BehaviorRelay<Bool> { get set }
    var navigateToDetailReady: BehaviorRelay<CountryDetailViewModel?> { get set }
    var mainScreenApi: MainScreenApi? { get set }
    
    func getCountryList()
    func navigateToDetail(code: String)
}

final class CountryListViewModel: CountryListViewModelProtocol {
    
    // MARK: - Properties
    private var limit: Int = 10
    private var bag = DisposeBag()
    
    var countryListDatasource = BehaviorRelay<[Datum]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var onError = BehaviorRelay<Bool>(value: false)
    var navigateToDetailReady = BehaviorRelay<CountryDetailViewModel?>(value: nil)
    var mainScreenApi: MainScreenApi?
    
    // MARK: - Initilizations
    init() { }
    
    //MARK: - Public Methods
    func getCountryList() {
        Observable.just((limit))
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.isLoading.accept(true)
            })
            .flatMap { [weak self] limit in
                self?.mainScreenApi?.getCountryList(limit: limit) ?? .empty()
            }
            .observe(on: MainScheduler.instance)
            .do(onError: { _ in self.onError.accept(true) })
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] countryListResponse in
                guard let self = self else { return }
                self.updateCountryListDatasource(with: countryListResponse)
            })
            .disposed(by: bag)
    }
    
    func navigateToDetail(code: String) {
        let detailViewModel = CountryDetailViewModel()
        detailViewModel.countryCodeDatasource.accept(code)
        navigateToDetailReady.accept(detailViewModel)
    }
}

//MARK: - Helper Methods
extension CountryListViewModel {
    private func updateCountryListDatasource(with country: Country) {
        self.countryListDatasource.accept(country.data)
    }
}
