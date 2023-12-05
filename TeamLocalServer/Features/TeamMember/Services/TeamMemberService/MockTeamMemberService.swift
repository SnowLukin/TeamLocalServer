//
//  MockTeamMemberService.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 04.12.2023.
//

import Foundation
import Combine

final class MockTeamMemberService: TeamMemberServiceProtocol {
    func loadAll() -> AnyPublisher<[TeamMember], Error> {
        performRequest(TeamMember.sampleMembers)
    }
    
    func load(by id: Int) -> AnyPublisher<TeamMember, Error> {
        guard let teamMember = TeamMember.sampleMembers.first(where: { $0.id == id }) else {
            return Fail(error: URLError(.resourceUnavailable))
                .eraseToAnyPublisher()
        }
        return performRequest(teamMember)
    }
    
    func create(_ teamMember: TeamMember) -> AnyPublisher<TeamMember, Error> {
        performRequest(teamMember)
    }
    
    func deleteAll() -> AnyPublisher<Void, Error> {
        performVoidRequest()
    }
    
    func delete(by id: Int) -> AnyPublisher<Void, Error> {
        performVoidRequest()
    }
    
    func update(_ teamMember: TeamMember) -> AnyPublisher<TeamMember, Error> {
        performRequest(teamMember)
    }
    
    private func performVoidRequest() -> AnyPublisher<Void, Error> {
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func performRequest<T>(_ object: T) -> AnyPublisher<T, Error> where T: Decodable {
        Just(object)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
