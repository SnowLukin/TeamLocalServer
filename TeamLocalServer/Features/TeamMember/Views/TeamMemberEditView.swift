//
//  TeamMemberEditView.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI

struct TeamMemberEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var vm: TeamMemberEditViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    SectionedTextField(title: "Name", placeholder: "Name", text: $vm.nameTF)
                    SectionedTextField(title: "Surname", placeholder: "Surname", text: $vm.surnameTF)
                    SectionedTextField(title: "Middle Name", placeholder: "Middle Name", text: $vm.middleNameTF)
                    SectionedTextField(title: "Role", placeholder: "Role", text: $vm.roleTF)
                    SectionedView(sectionName: "Hiring Date") {
                        DatePicker("", selection: $vm.hiringDate, in: ...Date.now, displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(.compact)
                    }
                }.padding()
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("New Member")
            .overlay(alignment: .bottom) {
                ZStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("Save")
                            .bold()
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue, in: .rect(cornerRadius: 10))
                            .padding(.horizontal)
                    }.buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(AppColors.secondaryBackground)
            }
            
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    TeamMemberEditView(vm: .init(service: MockTeamMemberService()))
}
