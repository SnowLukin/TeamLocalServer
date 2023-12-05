//
//  TeamMember+Samples.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation

extension TeamMember {
    
    static var sampleMember: TeamMember {
        TeamMember(
            id: 1,
            name: "Alice",
            surname: "Johnson",
            middleName: "Marie",
            role: "Developer",
            specialization: "Mobile",
            hiringDate: Date(timeIntervalSince1970: 1579056000)
        )
    }
    
    static var sampleMembers: [TeamMember] {
        [
            TeamMember(
                id: 1,
                name: "Alice",
                surname: "Johnson",
                middleName: "Marie",
                role: "Developer",
                specialization: "Mobile",
                hiringDate: Date(timeIntervalSince1970: 1579056000)
            ),
            TeamMember(
                id: 2,
                name: "Bob",
                surname: "Smith",
                middleName: "Andrew",
                role: "Designer",
                specialization: "Backend",
                hiringDate: Date(timeIntervalSince1970: 1560134400)
            ),
            TeamMember(
                id: 3,
                name: "Charlie",
                surname: "Davis",
                middleName: "Lee",
                role: "Project Manager",
                specialization: "All",
                hiringDate: Date(timeIntervalSince1970: 1616371200)
            )
        ]
    }
}
