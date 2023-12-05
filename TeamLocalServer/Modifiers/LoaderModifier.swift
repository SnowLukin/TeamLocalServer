//
//  LoaderModifier.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 05.12.2023.
//

import SwiftUI

struct LoaderModifier: ViewModifier {
    let loaderTitle: String
    let isLoading: Bool
    
    init(_ loaderTitle: String, isLoading: Bool) {
        self.loaderTitle = loaderTitle
        self.isLoading = isLoading
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isLoading ? 2 : 0)
            if isLoading {
                ProgressView(loaderTitle)
            }
        }
    }
}

extension View {
    func withLoading(_ text: String, isLoading: Bool) -> some View {
        self.modifier(LoaderModifier(text, isLoading: isLoading))
    }
}
