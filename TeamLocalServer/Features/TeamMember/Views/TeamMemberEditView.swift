//
//  TeamMemberEditView.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI

struct TeamMemberEditView: View {
    
    
    var body: some View {
        ScrollView {
            Text("Something")
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottom) {
            ZStack {
                Button {
                    
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
    }
}

#Preview {
    TeamMemberEditView()
}
