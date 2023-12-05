//
//  TeamMemberListView.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI

struct TeamMemberListView: View {
    
    @StateObject var vm: TeamMemberListViewModel
    
    @State private var showCreateMember = false
    
    var body: some View {
        NavigationStack {
            contentList
                .withLoading("Fetching Team Members", isLoading: vm.isLoading)
                .onAppear {
                    withAnimation {
                        vm.loadTeamMembers()
                    }
                }
                .sheet(isPresented: $showCreateMember, onDismiss: vm.loadTeamMembers) {
                    TeamMemberEditView(vm: .init(service: vm.service))
                }
                .navigationTitle("Team members")
        }
    }
}

#Preview {
    TeamMemberListView(vm: .init(service: MockTeamMemberService()))
}

extension TeamMemberListView {
    
    private var contentList: some View {
        List {
            if !vm.teamMembers.isEmpty {
                memberSection
            }
            hotKeySection
        }
        .refreshable {
            withAnimation {
                vm.loadTeamMembers()
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                showCreateMember.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(.blue, in: .circle)
                    .padding()
            }
        }
    }
    
    private var memberSection: some View {
        Section("Members") {
            ForEach(vm.teamMembers) { member in
                NavigationLink {
                    TeamMemberInfoView(vm: .init(teamMemberId: member.id, service: vm.service))
                } label: {
                    HStack {
                        Image(systemName: "person.fill")
                            .font(.title3)
                            .foregroundStyle(AppColors.darkGray)
                            .padding(8)
                            .background(AppColors.lightGray, in: .circle)
                        VStack(alignment: .leading) {
                            Text(member.fullName)
                            Text(member.role)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }.padding(.leading, 5)
                    }
                }
            }.onDelete { indexSet in
                withAnimation {
                    indexSet.forEach { index in
                        let id = vm.teamMembers[index].id
                        vm.deleteTeamMember(by: id)
                    }
                    vm.teamMembers.remove(atOffsets: indexSet)
                }
            }
        }
    }
    
    private var hotKeySection: some View {
        Section("Hot keys") {
            Button("Refresh") {
                withAnimation {
                    vm.loadTeamMembers()
                }
            }
            
            Button("Remove all") {
                withAnimation {
                    vm.deleteTeamMembers()
                    vm.teamMembers.removeAll()
                }
            }
        }
    }
}
