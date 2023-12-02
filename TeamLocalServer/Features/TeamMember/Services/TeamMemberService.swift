//
//  TeamMemberListService.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation
import Combine

final class TeamMemberService {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadAll() -> AnyPublisher<[TeamMember], Error> {
        let request = TeamMemberProvider.getMembers.makeRequest
        return httpClient
            .publisher(request: request)
            .tryMap(GenericApiHTTPRequestMapper.map)
            .eraseToAnyPublisher()
    }
    
    func load(by id: Int) -> AnyPublisher<TeamMember, Error> {
        let request = TeamMemberProvider.getMember(id).makeRequest
        return httpClient
            .publisher(request: request)
            .tryMap(GenericApiHTTPRequestMapper.map)
            .eraseToAnyPublisher()
    }
}
