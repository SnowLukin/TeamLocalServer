//
//  TeamMemberEditViewModel.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 05.12.2023.
//

import SwiftUI
import Combine

final class TeamMemberEditViewModel: ObservableObject {
    
    let teamMemberId: Int?
    let teamMember: TeamMember?
    private let service: TeamMemberServiceProtocol
    
    @Published var nameTF = ""
    @Published var surnameTF = ""
    @Published var middleNameTF = ""
    @Published var roleTF = ""
    @Published var specTF = ""
    @Published var hiringDate = Date.now
    
    private var cancellables = Set<AnyCancellable>()
    
    init(id: Int? = nil, teamMember: TeamMember? = nil, service: TeamMemberServiceProtocol = TeamMemberService()) {
        self.teamMemberId = id
        self.teamMember = teamMember
        self.service = service
        
        setup(with: teamMember)
    }
    
    func onSave() {
        let newTeamMember = createNewTeamMember(with: teamMemberId)
        if teamMemberId != nil {
            updateMember(newTeamMember)
        } else {
            createMember(newTeamMember)
        }
    }
    
    private func createMember(_ teamMember: TeamMember) {
        service
            .create(teamMember)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { newTeamMember in
                debugPrint(newTeamMember)
            }
            .store(in: &cancellables)
    }
    
    private func updateMember(_ teamMember: TeamMember) {
        service
            .update(teamMember)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { updatedTeamMember in
                debugPrint(updatedTeamMember)
            }
            .store(in: &cancellables)
    }
    
    private func setup(with teamMember: TeamMember?) {
        guard let teamMember else { return }
        nameTF = teamMember.name.withDefaultValue()
        surnameTF = teamMember.surname.withDefaultValue()
        middleNameTF = teamMember.middleName.withDefaultValue()
        roleTF = teamMember.role.withDefaultValue()
        specTF = teamMember.specialization.withDefaultValue()
        hiringDate = teamMember.hiringDate ?? .now
    }
    
    private func createNewTeamMember(with id: Int?) -> TeamMember {
        TeamMember(
            id: id.withDefaultValue(-1),
            name: nameTF,
            surname: surnameTF,
            middleName: middleNameTF,
            role: roleTF,
            specialization: specTF,
            hiringDate: hiringDate
        )
    }
}
