//
//  CountriesTests.swift
//  CountriesTests
//
//  Created by Gizem Boskan on 26.11.2021.
//

import XCTest
@testable import Countries

class CountriesTests: XCTestCase {
    
    enum MockCountry: String {
        case Country1
        case Country2
        case Country3
    }
    
    private var viewModel: CountryDetailViewModelProtocol?
    private var mockCountryDetailApi: CountryDetailApiProtocol?
    
    override func setUp() {
        // To only test with Country1:
        viewModel = CountryDetailViewModel(code: MockCountry.Country1.rawValue, isFav: true)
        mockCountryDetailApi = CountryDetailApiImplementationMock()
        viewModel?.countryDetailApi = mockCountryDetailApi
    }
    
    func testCountryDetail()  {
        
        viewModel?.getCountryDetail()
        XCTAssertEqual(viewModel?.countryDetailDatasource.value?.data.code, "US")
        XCTAssertNotEqual(viewModel?.countryDetailDatasource.value?.data.code, "TR")
        
    }
}
