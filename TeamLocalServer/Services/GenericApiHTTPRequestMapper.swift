//
//  GenericApiHTTPRequestMapper.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation

struct GenericApiHTTPRequestMapper {
    static func map<T>(data: Data, response: HTTPURLResponse) throws -> T where T: Decodable {
        if (200..<300) ~= response.statusCode {
            do {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let decoder = JSONDecoder().snakeCased()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                return try decoder.decode(T.self, from: data)
            } catch {
                throw ApiError.basicError(error)
            }
        }
        
        if let error = try? JSONDecoder().snakeCased().decode(ApiErrorDTO.self, from: data) {
            throw ApiError.custom(error)
        } else {
            throw ApiError.emptyErrorWithStatusCode(response.statusCode.description)
        }
    }
    
    static func map(data: Data, response: HTTPURLResponse) throws {
        if (200..<300) ~= response.statusCode {
            return
        }
        
        if let error = try? JSONDecoder().snakeCased().decode(ApiErrorDTO.self, from: data) {
            throw ApiError.custom(error)
        } else {
            throw ApiError.emptyErrorWithStatusCode(response.statusCode.description)
        }
    }
}
