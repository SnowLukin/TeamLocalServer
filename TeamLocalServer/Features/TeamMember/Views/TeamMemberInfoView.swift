//
//  TeamMemberInfoView.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI

struct TeamMemberInfoView: View {
    
    @ObservedObject var vm: TeamMemberInfoViewModel
    
    @State private var showEditingView = false
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    header
                    Divider()
                    infoContent
                    Divider()
                    editButton
                }
                .padding(.top)
                .withLoading("Loading Team Member", isLoading: vm.isLoading)
            }
        }
        .refreshable {
            vm.load()
        }
        .onAppear {
            vm.load()
        }
        .sheet(isPresented: $showEditingView, onDismiss: vm.load, content: {
            if let teamMember = vm.teamMember {
                TeamMemberEditView(vm: .init(
                    id: vm.teamMemberId,
                    teamMember: teamMember,
                    service: vm.service)
                )
            }
        })
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    TeamMemberInfoView(
        vm: .init(
            teamMemberId: 1,
            service: MockTeamMemberService()
        )
    )
}

extension TeamMemberInfoView {
    private var header: some View {
        HStack {
            Image(systemName: "person.fill")
                .resizable()
                .foregroundStyle(AppColors.darkGray)
                .frame(width: 50, height: 50)
                .padding()
                .background(AppColors.lightGray, in: .circle)
            VStack(alignment: .leading) {
                Text(vm.initials())
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(vm.role())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fontWeight(.light)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
    }
    
    private var infoContent: some View {
        VStack(spacing: 20) {
            SectionedView(sectionName: "Full Name") {
                Text(vm.fullName())
            }
            
            SectionedView(sectionName: "Role") {
                Text(vm.role())
            }
            
            SectionedView(sectionName: "Specialization") {
                Text(vm.spec())
                    .bold()
                    .padding(5)
                    .padding(.horizontal, 7)
                    .background(.orange.gradient, in: .rect(cornerRadius: 10))
            }
            
            SectionedView(sectionName: "Hiring date") {
                Text(vm.hiringDate())
            }
            
            SectionedView(sectionName: "Working for") {
                Text(vm.workingFor())
            }
        }.padding()
    }
    
    private var editButton: some View {
        Button {
            showEditingView.toggle()
        } label: {
            Text("Edit")
                .bold()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(.blue, in: .rect(cornerRadius: 10))
                .padding(.horizontal)
        }.buttonStyle(.plain)
    }
}
