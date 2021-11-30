//
//  CountryDetailApi.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation
import RxSwift

protocol CountryDetailApiProtocol {
    func getCountryDetail(code: String) -> Observable<CountryDetail>
}
final class CountryDetailApiImplementation: CountryDetailApiProtocol {
    func getCountryDetail(code: String) -> Observable<CountryDetail> {
        guard let url = URL.getContryDetails(code: code) else { return .empty() }
        return URLRequest.load(resource: Resource<CountryDetail>(url: url))
    }
}

//- FOR TESTING:
//final class CountryDetailApiImplementationMock: CountryDetailApiProtocol {
//    func getCountryDetail(code: String) -> Observable<CountryDetail> {
//        return .empty()
//    }
//}
