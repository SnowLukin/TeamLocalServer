//
//  TeamMemberListService.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import Foundation
import Combine

final class TeamMemberService: TeamMemberServiceProtocol {
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient = URLSession.shared) {
        self.httpClient = httpClient
    }
    
    func loadAll() -> AnyPublisher<[TeamMember], Error> {
        let request = TeamMemberProvider.getMembers.makeRequest
        return performRequest(request)
    }
    
    func load(by id: Int) -> AnyPublisher<TeamMember, Error> {
        let request = TeamMemberProvider.getMember(id).makeRequest
        return performRequest(request)
    }
    
    func create(_ teamMember: TeamMember) -> AnyPublisher<TeamMember, Error> {
        let request = TeamMemberProvider.createMember(teamMember).makeRequest
        return performRequest(request)
    }
    
    func deleteAll() -> AnyPublisher<Void, Error> {
        let request = TeamMemberProvider.deleteMembers.makeRequest
        return performVoidRequest(request)
    }
    
    func delete(by id: Int) -> AnyPublisher<Void, Error> {
        let request = TeamMemberProvider.deleteMember(id).makeRequest
        return performVoidRequest(request)
    }
    
    func update(_ teamMember: TeamMember) -> AnyPublisher<TeamMember, Error> {
        let request = TeamMemberProvider.update(teamMember).makeRequest
        return performRequest(request)
    }
    
    private func performRequest<T>(_ request: URLRequest) -> AnyPublisher<T, Error> where T: Decodable {
        httpClient
            .publisher(request: request)
            .tryMap(GenericApiHTTPRequestMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func performVoidRequest(_ request: URLRequest) -> AnyPublisher<Void, Error> {
        httpClient
            .publisher(request: request)
            .tryMap { _ in () }
            .eraseToAnyPublisher()
    }
}
