//
//  TeamMemberListViewModel.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI
import Combine

final class TeamMemberListViewModel: ObservableObject {
    
    let service: TeamMemberServiceProtocol
    
    @Published var teamMembers: [TeamMember] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(service: TeamMemberServiceProtocol = TeamMemberService()) {
        self.service = service
    }
    
    func loadTeamMembers() {
        isLoading = true
        service
            .loadAll()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { [weak self] newTeamMembers in
                self?.teamMembers = newTeamMembers
            }
            .store(in: &cancellables)
    }
    
    func deleteTeamMembers() {
        service
            .deleteAll()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func deleteTeamMember(by id: Int) {
        service
            .delete(by: id)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
}
