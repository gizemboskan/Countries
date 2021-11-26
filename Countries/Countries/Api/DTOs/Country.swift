//
//  Country.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation

// TODO: DELETE links and metadata

// MARK: - Country
struct Country: Decodable {
    let data: [Datum]
    let links: [Link]
    let metadata: Metadata
}

// MARK: - Datum
struct Datum: Decodable {
    let code: String
    let currencyCodes: [String]
    let name, wikiDataID: String
    
    enum CodingKeys: String, CodingKey {
        case code, currencyCodes, name
        case wikiDataID = "wikiDataId"
    }
}

// MARK: - Link
struct Link: Decodable {
    let rel, href: String
}

// MARK: - Decodable
struct Metadata: Decodable {
    let currentOffset, totalCount: Int
}
