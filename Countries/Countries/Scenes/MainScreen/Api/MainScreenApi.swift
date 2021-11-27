//
//  MainScreenApi.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation
import RxSwift

protocol MainScreenApi {
    func getCountryList(limit: Int) -> Observable<Country>
}

final class MainScreenApiImplementation: MainScreenApi {
    func getCountryList(limit: Int) -> Observable<Country> {
        guard let url = URL.getContryList(limit: limit) else { return .empty() }
        return URLRequest.load(resource: Resource<Country>(url: url))
    }
}
//- FOR TESTING:
final class MainScreenApiImplementationMock: MainScreenApi {
    func getCountryList(limit: Int) -> Observable<Country> {
        return .empty()
    }
}
