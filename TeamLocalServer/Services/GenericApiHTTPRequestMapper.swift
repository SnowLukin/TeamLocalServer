//
//  GenericApiHTTPRequestMapper.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation

struct GenericApiHTTPRequestMapper {
    static let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    static func map<T>(data: Data, response: HTTPURLResponse) throws -> T where T: Decodable {
        if (200..<300) ~= response.statusCode {
            do {
                return try jsonDecoder.decode(T.self, from: data)
            } catch {
                throw ApiError.basicError(error)
            }
        }
        
        if let error = try? jsonDecoder.decode(ApiErrorDTO.self, from: data) {
            throw ApiError.custom(error)
        } else {
            throw ApiError.emptyErrorWithStatusCode(response.statusCode.description)
        }
    }
}
