//
//  TeamMemberProvider.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation

enum TeamMemberProvider {
    case getMembers
    case getMember(Int)
    case createMember(TeamMember)
    case deleteMembers
    case deleteMember(Int)
    case update(TeamMember)
}

extension TeamMemberProvider: ApiEndpoint {
    var baseUrlString: String {
//        "http://172.20.10.3:8080"
        "http://localhost:8080"
    }
    
    var apiPath: String {
        "api"
    }
    
    var apiVersion: String? {
        "v1"
    }
    
    var separatorPath: String? {
        nil
    }
    
    var path: String {
        switch self {
        case .getMembers, .createMember, .deleteMembers:
            "team-members"
        case .getMember(let id), .deleteMember(let id):
            "team-members/\(id)"
        case .update(let teamMember):
            "team-members/\(teamMember.id.withDefaultValue(-1))"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .deleteMember, .deleteMembers:
            nil
        case .getMembers, .getMember, .createMember, .update:
            ["Content-Type": "application/json"]
        }
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var params: [String : Any]? {
        nil
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMembers, .getMember:
            return .GET
        case .createMember:
            return .POST
        case .deleteMembers, .deleteMember:
            return .DELETE
        case .update:
            return .PUT
        }
    }
    
    var body: Data? {
        switch self {
        case .getMembers, .getMember, .deleteMembers, .deleteMember:
            return nil
        case .createMember(let teamMember), .update(let teamMember):
            let encoder = JSONEncoder.teamMemberEncoder()
            do {
                let encodedData = try encoder.encode(teamMember)
                NSLog(String(data: encodedData, encoding: .utf8) ?? "Failed to encode data")
                return encodedData
            } catch {
                NSLog(error.localizedDescription)
                return nil
            }
        }
    }
}
