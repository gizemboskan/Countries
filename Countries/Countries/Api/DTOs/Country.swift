//
//  Country.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation

// MARK: - Country
struct Country: Decodable {
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Decodable {
    let code: String
    let name, wikiDataID: String
    
    enum CodingKeys: String, CodingKey {
        case code, name
        case wikiDataID = "wikiDataId"
    }
}
