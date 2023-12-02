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
}

extension TeamMemberProvider: ApiEndpoint {
    var baseUrlString: String {
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
        case .getMembers:
            "team-members"
        case .getMember(let id):
            "team-members/\(id)"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getMembers, .getMember:
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
        }
    }
    
    var body: Data? {
        switch self {
        case .getMembers, .getMember:
            nil
        }
    }
}
