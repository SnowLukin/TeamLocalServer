//
//  TeamMember.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation

struct TeamMember: Identifiable, Codable {
    let id: Int
    let name: String
    let surname: String
    let middleName: String
    let role: String
    let hiringDate: Date
}
