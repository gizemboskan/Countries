//
//  CountryListViewModel.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import CoreData

protocol CountryListViewModelProtocol {
    var countryListDatasource: BehaviorRelay<[Datum]> { get set }
    var savedCountryListDatasource: BehaviorRelay<[CountryModel]> { get set }
    var savedCountryCodesDatasource: BehaviorRelay<[String]> { get set }
    var isLoading: BehaviorRelay<Bool> { get set }
    var onError: BehaviorRelay<Bool> { get set }
    var navigateToDetailReady: BehaviorRelay<CountryDetailViewModel?> { get set }
    var mainScreenApi: MainScreenApi? { get set }
    
    func getCountryList()
    func getFavorites()
    func checkFavoriteUpdates()
    func navigateToDetail(code: String)
}

final class CountryListViewModel: CountryListViewModelProtocol {
    
    // MARK: - Properties
    private var limit: Int = 10
    private var bag = DisposeBag()
    
    var countryListDatasource = BehaviorRelay<[Datum]>(value: [])
    var savedCountryListDatasource = BehaviorRelay<[CountryModel]>(value: [])
    var savedCountryCodesDatasource = BehaviorRelay<[String]>(value: [])
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
                // convert DTO to the UI Model
                self.updateSavedCountryListDatasource(with: countryListResponse.data.map({ CountryModel(code: $0.code, name: $0.name, isFav: self.savedCountryCodesDatasource.value.contains($0.code))
                }))
                
            })
            .disposed(by: bag)
    }
    
    func getFavorites(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedCountries")
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    guard let savedCountryCode = result.value(forKey: "savedCountryCode") as? [String] else { return }
                    self.updateSavedCountryListCodeDatasource(with: savedCountryCode)
                    self.checkFavoriteUpdates()
                }
            }
        } catch {
            print("Error")
        }
        
    }
    
    func checkFavoriteUpdates() {
        if !countryListDatasource.value.isEmpty {
            // convert DTO to the UI Model
            self.updateSavedCountryListDatasource(with: countryListDatasource.value.map({ CountryModel(code: $0.code, name: $0.name, isFav: self.savedCountryCodesDatasource.value.contains($0.code))
            }))
            //countryListDatasource.filter({savedCountryCodesDatasource.value.contains($0.code)} )}
        }
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
    
    private func updateSavedCountryListDatasource(with country: [CountryModel]) {
        self.savedCountryListDatasource.accept(country)
    }
    
    private func updateSavedCountryListCodeDatasource(with countryCode: [String]) {
        self.savedCountryCodesDatasource.accept(savedCountryCodesDatasource.value + countryCode)
    }
    
}
