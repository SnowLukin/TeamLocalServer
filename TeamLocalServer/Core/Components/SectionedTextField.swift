//
//  SectionedTextField.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI

struct SectionedTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 5) {
            SectionTitleText(title)
            TextField(placeholder, text: $text)
                .padding()
                .background(AppColors.secondaryBackground, in: .rect(cornerRadius: 10))
        }
    }
}
