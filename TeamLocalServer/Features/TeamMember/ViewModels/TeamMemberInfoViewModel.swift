//
//  TeamMemberViewModel.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI
import Combine

final class TeamMemberInfoViewModel: ObservableObject {
    let service: TeamMemberServiceProtocol
    let teamMemberId: Int
    
    @Published var teamMember: TeamMember?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(teamMemberId: Int, service: TeamMemberServiceProtocol = TeamMemberService()) {
        self.service = service
        self.teamMemberId = teamMemberId
    }
    
    func load() {
        withAnimation {
            isLoading = true
            service
                .load(by: teamMemberId)
                .sink { [weak self] completion in
                    self?.isLoading = false
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                    }
                } receiveValue: { [weak self] loadedTeamMember in
                    self?.teamMember = loadedTeamMember
                    debugPrint(loadedTeamMember)
                }
                .store(in: &cancellables)
        }
    }
    
    func update() {
        guard let teamMember else { return }
        isLoading = true
        service
            .update(teamMember)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { [weak self] updatedTeamMember in
                self?.teamMember = updatedTeamMember
            }
            .store(in: &cancellables)
    }
    
    func fullName() -> String {
        teamMember?.fullName ?? "No data"
    }
    
    func initials() -> String {
        teamMember?.initials ?? "No data"
    }
    
    func hiringDate() -> String {
        teamMember?.hiringDate.teamMemberFormat() ?? "No data"
    }
    
    func role() -> String {
        teamMember?.role ?? "No data"
    }
    
    func workingFor() -> String {
        guard var days = teamMember?.hiringDate.daysFromToday() else {
            return "No data"
        }
        // if the date was before today then we want to see positive number
        // otherwise negative
        days *= -1
        return "\(days) days"
    }
}
