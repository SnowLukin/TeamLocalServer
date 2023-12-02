//
//  TeamMemberListView.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI

struct TeamMemberListView: View {
    
    @StateObject var vm: TeamMemberListViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section("Hot keys") {
                    Button("Refresh") {
                        withAnimation {
                            vm.loadTeamMembers()
                        }
                    }
                }
                
                ForEach(vm.teamMembers) { member in
                    Text(member.name)
                }
            }
            .onAppear(perform: {
                vm.loadTeamMembers()
            })
            .overlay(alignment: .bottomTrailing, content: {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .padding(12)
                        .background(.blue, in: .circle)
                        .padding()
                }
            })
            .navigationTitle("Team members")
        }
    }
}

#Preview {
    let mockClient = MockTeamMemberListDecorator()
    return TeamMemberListView(vm: .init(httpClient: mockClient))
}
