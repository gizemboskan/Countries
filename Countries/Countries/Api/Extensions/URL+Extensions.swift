//
//  URL+Extensions.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation

enum Endpoints {
    static let apiKey = "ce79487b30msh32ac78441e8077ap1b4a07jsnc780be240de7"
    static let base = "https://wft-geo-db.p.rapidapi.com/v1"
    static let apiKeyParam = "rapidapi-key=\(apiKey)"
}

extension URL {
    
    static func getContryList(limit: Int) -> URL? {
        URL(string: Endpoints.base + "/geo/countries" + "?limit=\(limit)&" + Endpoints.apiKeyParam)
    }
    
    static func getContryDetails(code: String) -> URL? {
        URL(string: Endpoints.base + "/geo/countries/\(code)?" + Endpoints.apiKeyParam)
    }
}
