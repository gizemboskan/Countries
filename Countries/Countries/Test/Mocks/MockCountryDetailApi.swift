//
//  MockCountryDetailApi.swift
//  Countries
//
//  Created by Gizem Boskan on 29.11.2021.
//

import Foundation
import RxSwift
import RxCocoa

class CountryDetailApiImplementationMock: CountryDetailApiProtocol {
    
    func getCountryDetail(code: String) -> Observable<CountryDetail> {
        let bundle = Bundle.test
        let url = try? bundle.url(forResource: code, withExtension: "json").unwrap()
        let decoder = JSONDecoder()
        guard let url = url,
              let data = try? Data(contentsOf: url),
              let countryDetail = try? decoder.decode(CountryDetail.self, from: data)
        else { return .empty() }
        return Observable.just(countryDetail)
            .asObservable()
    }
}

private extension Bundle {
    class Dummy { }
    static let test = Bundle(for: Dummy.self)
}
