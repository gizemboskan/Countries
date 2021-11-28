//
//  CountryTableViewCellViewModel.swift
//  Countries
//
//  Created by Gizem Boskan on 28.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

protocol CountryTableViewCellViewModelProtocol {
    var mainScreenApi: MainScreenApiProtocol? { get set }
    func changeFavoriteCountry()
    
}

final class CountryTableViewCellViewModel: CountryTableViewCellViewModelProtocol {
    
    var mainScreenApi: MainScreenApiProtocol?
    private var bag = DisposeBag()
    private var code: String
    private var isFav: Bool
    
    init(code: String, isFav: Bool) {
        self.code = code
        self.isFav = isFav
    }
    //MARK: - Public Methods
    func changeFavoriteCountry() {
        mainScreenApi?.changeFavoriteCountry(code: code, isFav: isFav)
    }
}
