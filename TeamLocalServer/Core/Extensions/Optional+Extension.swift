//
//  Optional+String.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 05.12.2023.
//

import Foundation

extension Optional where Wrapped == String {
    
    func withDefaultValue(_ defaultValue: String = "") -> String {
        self ?? defaultValue
    }
    
    var firstCharOrEmpty: String {
        guard let firstChar = self?.first else {
            return ""
        }
        return String(firstChar)
    }
}

extension Optional where Wrapped == Int {
    func withDefaultValue(_ defaultValue: Int = 0) -> Int {
        self ?? defaultValue
    }
}
