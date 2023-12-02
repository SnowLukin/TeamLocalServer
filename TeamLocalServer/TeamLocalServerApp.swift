//
//  TeamLocalServerApp.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI

@main
struct TeamLocalServerApp: App {
    var body: some Scene {
        WindowGroup {
            TeamMemberListView(vm: .init(httpClient: MockTeamMemberListDecorator()))
        }
    }
}
