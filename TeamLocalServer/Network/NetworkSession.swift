//
//  NetworkSession.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation
import Combine

protocol NetworkSession: AnyObject {
    func publisher<T>(_ request: URLRequest, decodingType: T.Type) -> AnyPublisher<T, ApiError> where T: Decodable
}

extension URLSession: NetworkSession {
    func publisher<T>(_ request: URLRequest, decodingType: T.Type) -> AnyPublisher<T, ApiError> where T : Decodable {
        var newRequest = request
        return dataTaskPublisher(for: newRequest)
            .tryMap({ result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw ApiError.requestFailed
                }
                if (200..<300) ~= httpResponse.statusCode {
                    return result.data
                }
                if let error = try? JSONDecoder().decode(ApiErrorDTO.self, from: result.data) {
                    throw ApiError.custom(error)
                } else {
                    throw ApiError.emptyErrorWithStatusCode(httpResponse.statusCode.description)
                }
            })
            .decode(type: T.self, decoder: JSONDecoder().snakeCased())
            .mapError { error -> ApiError in
                if let error = error as? ApiError {
                    return error
                }
                return ApiError.basicError(error)
            }
            .eraseToAnyPublisher()
    }
}
