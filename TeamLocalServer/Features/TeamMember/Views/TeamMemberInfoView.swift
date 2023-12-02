//
//  TeamMemberInfoView.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI

struct TeamMemberInfoView: View {
    
    @ObservedObject var vm: TeamMemberInfoViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .foregroundStyle(AppColors.darkGray)
                        .frame(width: 50, height: 50)
                        .padding()
                        .background(AppColors.lightGray, in: .circle)
                    VStack(alignment: .leading) {
                        Text("Donald J.T.")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Mobile Developer")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fontWeight(.light)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                Divider()
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 5) {
                        SectionTitleText("Full Name")
                        Text("First Second Middle")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        SectionTitleText("Role")
                        Text("Mobile Developer")
                            .bold()
                            .padding(5)
                            .padding(.horizontal, 7)
                            .background(.orange.gradient, in: .rect(cornerRadius: 10))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        SectionTitleText("Hiring date")
                        Text("23 September, 2023")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        SectionTitleText("Working for")
                        Text("180 days")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.padding()
                Divider()
                Button {
                    
                } label: {
                    Text("Edit")
                        .bold()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(.blue, in: .rect(cornerRadius: 10))
                        .padding(.horizontal)
                }.buttonStyle(.plain)
            }.padding(.top, 40)
        }
    }
}

#Preview {
    let client = MockTeamMemberHTTPDecorator()
    return TeamMemberInfoView(vm: .init(teamMemberId: 0, httpClient: client))
}
