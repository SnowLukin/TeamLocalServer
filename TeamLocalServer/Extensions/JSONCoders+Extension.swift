//
//  JSONCoders+Extension.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 04.12.2023.
//

import Foundation

extension JSONDecoder {
    func snakeCased() -> JSONDecoder {
        self.keyDecodingStrategy = .convertFromSnakeCase
        return self
    }
}

extension JSONEncoder {
    func snakeCased() -> JSONEncoder {
        self.keyEncodingStrategy = .convertToSnakeCase
        return self
    }
}
