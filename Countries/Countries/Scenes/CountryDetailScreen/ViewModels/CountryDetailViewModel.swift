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
    var countryDetailDatasource: BehaviorRelay<CountryDetail?> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var onError: BehaviorRelay<Bool> { get set }
    var countryDetailApi: CountryDetailApiProtocol? { get set }
    var countryListRepository: CountryListRepository? { get set }
    var isFav: Bool { get set }
    
    func changeFavoriteCountry()
    func getCountryDetail()
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
    var countryDetailDatasource = BehaviorRelay<CountryDetail?>(value: nil)
    var countryDetailApi: CountryDetailApiProtocol?
    var countryListRepository: CountryListRepository?
    
    func getCountryDetail() {
        Observable.just((code))
            .do( onNext: { [isLoading] _ in
                isLoading.accept(true)
            })
            .flatMap { [weak self] countryCode in
                self?.countryDetailApi?.getCountryDetail(code: countryCode) ?? .empty()
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
        guard let countryListRepository = countryListRepository else { return }
        countryListRepository.changeFavoriteCountry(code: code, isFav: isFav)
        isFav.toggle()
    }
    
    deinit {
        print("no leak CountryDetailViewModel!")
    }
}

//MARK: - Helper Methods
extension CountryDetailViewModel {
    private func updateCountryDetailDatasource(with countryDetail: CountryDetail) {
        self.countryDetailDatasource.accept(countryDetail)
    }
}
