//
//  TeamMemberServiceProtocol.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 04.12.2023.
//

import Foundation
import Combine

protocol TeamMemberServiceProtocol {
    func loadAll() -> AnyPublisher<[TeamMember], Error>
    func load(by id: Int) -> AnyPublisher<TeamMember, Error>
    func create(_ teamMember: TeamMember) -> AnyPublisher<TeamMember, Error>
    func deleteAll() -> AnyPublisher<Void, Error>
    func delete(by id: Int) -> AnyPublisher<Void, Error>
    func update(_ teamMember: TeamMember) -> AnyPublisher<TeamMember, Error>
}
