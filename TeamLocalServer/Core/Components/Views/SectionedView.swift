//
//  SectionedView.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 04.12.2023.
//

import SwiftUI

struct SectionedView<Content: View>: View {
    
    let sectionName: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            SectionTitleText(sectionName)
            content
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}
