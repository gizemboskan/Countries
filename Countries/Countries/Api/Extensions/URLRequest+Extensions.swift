//
//  URLRequest+Extensions.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}

extension URLRequest {
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        Observable.just(resource.url)
            .flatMap{ url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.response(request: request)
            }.map{ response, data -> T in
                print(String(decoding: data, as: UTF8.self))
                if 200..<300 ~= response.statusCode {
                    return try JSONDecoder().decode(T.self, from: data)
                }else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }.asObservable()
    }
}
