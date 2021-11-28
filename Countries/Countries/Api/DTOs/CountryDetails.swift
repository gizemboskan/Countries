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
    let code: String
    let flagImageURI: String
    let name: String
    let wikiDataID: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case flagImageURI = "flagImageUri"
        case name
        case wikiDataID = "wikiDataId"
    }
}
