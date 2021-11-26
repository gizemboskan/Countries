//
//  CountryDetails.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation
// MARK: - Welcome
struct CountryDetails: Decodable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Decodable {
    let capital, code: String
    let currencyCodes: [String]
    let flagImageURI: String
    let name: String
    let numRegions: Int
    let wikiDataID: String
    
    enum CodingKeys: String, CodingKey {
        case capital, code, currencyCodes
        case flagImageURI = "flagImageUri"
        case name, numRegions
        case wikiDataID = "wikiDataId"
    }
}
