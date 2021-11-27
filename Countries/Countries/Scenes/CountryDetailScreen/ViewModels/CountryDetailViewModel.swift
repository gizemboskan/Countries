//
//  CountryDetailViewModel.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol CountryDetailViewModelProtocol {
    var countryCodeDatasource: BehaviorRelay<String?> { get set }
    var countryDetailDatasource: BehaviorRelay<CountryDetails?> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var onError: BehaviorRelay<Bool> { get set }
    var countryDetailApi: CountryDetailApi? { get set }
    
    func getcountryDetails(countryCode: String)
}

final class CountryDetailViewModel: CountryDetailViewModelProtocol {
    // MARK: - Properties
    private var bag = DisposeBag()
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    var onError = BehaviorRelay<Bool>(value: false)
    var countryCodeDatasource = BehaviorRelay<String?>(value: nil)
    var countryDetailDatasource = BehaviorRelay<CountryDetails?>(value: nil)
    var countryDetailApi: CountryDetailApi?
    
    func getcountryDetails(countryCode: String) {
        Observable.just((countryCode))
            .do( onNext: { [isLoading] _ in
                isLoading.accept(true)
            })
            .flatMap { [weak self] countryCode in
                self?.countryDetailApi?.getCountryDetails(code: countryCode) ?? .empty()
            }
            .observe(on: MainScheduler.instance)
            .do(onError: { _ in self.onError.accept(true) })
            .do(onDispose: { [isLoading] in isLoading.accept(false) })
            .subscribe(onNext: { [weak self] country in
                self?.updateCountryDetailDatasource(with: country)
            })
            .disposed(by: bag)
    }
}

//MARK: - Helper Methods
extension CountryDetailViewModel {
    private func updateCountryDetailDatasource(with countryDetail: CountryDetails) {
        self.countryDetailDatasource.accept(countryDetail)
    }
}
