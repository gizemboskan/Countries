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
    var countryDetailApi: CountryDetailApiProtocol? { get set }
    var mainScreenApi: MainScreenApiProtocol? { get set }
    var isFav: Bool { get set }
    
    func changeFavoriteCountry()
    func getcountryDetails(countryCode: String)
}

final class CountryDetailViewModel: CountryDetailViewModelProtocol {
    // MARK: - Properties
    private var bag = DisposeBag()
    private var code: String
    var isFav: Bool
    
    init(code: String, isFav: Bool) {
        self.code = code
        self.isFav = isFav
    }
    var isLoading = BehaviorRelay<Bool>(value: false)
    var onError = BehaviorRelay<Bool>(value: false)
    var countryCodeDatasource = BehaviorRelay<String?>(value: nil)
    var countryDetailDatasource = BehaviorRelay<CountryDetails?>(value: nil)
    var countryDetailApi: CountryDetailApiProtocol?
    var mainScreenApi: MainScreenApiProtocol?
    
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
    
    func changeFavoriteCountry() {
        guard let mainScreenApi = mainScreenApi else { return }
        mainScreenApi.changeFavoriteCountry(code: code, isFav: isFav)
        isFav.toggle()
    }
}

//MARK: - Helper Methods
extension CountryDetailViewModel {
    private func updateCountryDetailDatasource(with countryDetail: CountryDetails) {
        self.countryDetailDatasource.accept(countryDetail)
    }
}
