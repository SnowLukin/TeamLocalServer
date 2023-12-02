//
//  TeamMemberViewModel.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI
import Combine

final class TeamMemberInfoViewModel: ObservableObject {
    private let service: TeamMemberService
    let teamMemberId: Int
    
    @Published var teamMember: TeamMember?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(teamMemberId: Int, httpClient: HTTPClient = URLSession.shared) {
        self.service = TeamMemberService(httpClient: httpClient)
        self.teamMemberId = teamMemberId
    }
    
    func load() {
        service
            .load(by: teamMemberId)
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { [weak self] loadedTeamMember in
                self?.teamMember = loadedTeamMember
            }
            .store(in: &cancellables)
    }
}

final class MockTeamMemberHTTPDecorator: HTTPClient {
    private var mockHttpClient: MockHTTPClient
    
    init() {
        let mockData = MockHTTPClient.mockData(object: TeamMember.sampleMember)
        let mockHttpResponse = HTTPURLResponse(
            url: URL(string: "https://example.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        self.mockHttpClient = MockHTTPClient()
        self.mockHttpClient.mockResponse = (mockData, mockHttpResponse)
    }
    
    func publisher(request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        mockHttpClient.publisher(request: request)
    }
}
