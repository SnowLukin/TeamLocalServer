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
    
    static func teamMemberDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter.teamMemberDateFormatter()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}

extension JSONEncoder {
    func snakeCased() -> JSONEncoder {
        self.keyEncodingStrategy = .convertToSnakeCase
        return self
    }
    
    static func teamMemberEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter.teamMemberDateFormatter()
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        return encoder
    }
}

extension DateFormatter {
    static func teamMemberDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
}
