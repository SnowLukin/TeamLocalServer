//
//  HTTPClient.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation
import Combine

protocol HTTPClient {
    func publisher(request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error>
}

extension URLSession: HTTPClient {
    struct InvalidHTTPResponseError: Error {}
    
    func publisher(request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        return dataTaskPublisher(for: request)
            .tryMap({ result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw InvalidHTTPResponseError()
                }
                return (result.data, httpResponse)
            })
            .eraseToAnyPublisher()
    }
}

final class MockHTTPClient: HTTPClient {
    
    var response: (Data, HTTPURLResponse)?
    var error: Error?

    func publisher(request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }

        if let response = response {
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return Empty(completeImmediately: false)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
