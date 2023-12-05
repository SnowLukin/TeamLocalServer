//
//  TeamMemberEditViewModel.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 05.12.2023.
//

import SwiftUI
import Combine

final class TeamMemberEditViewModel: ObservableObject {
    
    let id: Int?
    let teamMember: TeamMember?
    private let service: TeamMemberServiceProtocol
    
    @Published var nameTF = ""
    @Published var surnameTF = ""
    @Published var middleNameTF = ""
    @Published var roleTF = ""
    @Published var hiringDate = Date.now
    
    private var cancellables = Set<AnyCancellable>()
    
    init(id: Int? = nil, teamMember: TeamMember? = nil, service: TeamMemberServiceProtocol = TeamMemberService()) {
        self.id = id
        self.teamMember = teamMember
        self.service = service
        
        if let teamMember {
            setup(with: teamMember)
        }
    }
    
    func handleSaving() {
        if let teamMember {
            updateMember(teamMember)
        } else {
            createMember()
        }
    }
    
    private func createMember() {
        let newTeamMember = TeamMember(
            id: 0,
            name: nameTF,
            surname: surnameTF,
            middleName: middleNameTF,
            role: roleTF,
            hiringDate: hiringDate
        )
        service
            .create(newTeamMember)
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
        let updatedTeamMember = TeamMember(
            id: teamMember.id,
            name: nameTF,
            surname: surnameTF,
            middleName: middleNameTF,
            role: roleTF,
            hiringDate: hiringDate
        )
        
        service
            .update(updatedTeamMember)
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
    
    private func setup(with teamMember: TeamMember) {
        nameTF = teamMember.name
        surnameTF = teamMember.surname
        middleNameTF = teamMember.middleName
        roleTF = teamMember.role
        hiringDate = teamMember.hiringDate
    }
}
