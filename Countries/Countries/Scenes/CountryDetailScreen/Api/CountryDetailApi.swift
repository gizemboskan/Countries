//
//  CountryDetailApi.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation
import RxSwift

protocol CountryDetailApi {
    
}
extension CountryDetailApi {
    func getCountryDetails(code: String) -> Observable<CountryDetails> {
        guard let url = URL.getContryDetails(code: code) else { return .empty() }
        return URLRequest.load(resource: Resource<CountryDetails>(url: url))
    }
}
