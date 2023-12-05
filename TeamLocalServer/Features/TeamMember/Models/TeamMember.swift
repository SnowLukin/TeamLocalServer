//
//  TeamMember.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation

struct TeamMember: Identifiable, Codable, Hashable {
    let id: Int?
    let name: String?
    let surname: String?
    let middleName: String?
    let role: String?
    let specialization: String?
    let hiringDate: Date?
}

extension TeamMember {
    var initials: String {
        "\(surname.withDefaultValue()) \(name.firstCharOrEmpty).\(middleName.firstCharOrEmpty)."
    }
    
    var fullName: String {
        "\(surname.withDefaultValue()) \(name.withDefaultValue()) \(middleName.withDefaultValue())"
    }
}
