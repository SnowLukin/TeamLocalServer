//
//  TeamMemberListViewModel.swift
//  TeamLocalServer
//
//  Created by Snow Lukin on 01.12.2023.
//

import SwiftUI
import Combine

final class TeamMemberListViewModel: ObservableObject {
    
    private let service: TeamMemberService
    
    @Published var teamMembers: [TeamMember] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(httpClient: HTTPClient = URLSession.shared) {
        self.service = TeamMemberService(httpClient: httpClient)
    }
    
    func loadTeamMembers() {
        service
            .loadAll()
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                }
            } receiveValue: { [weak self] newTeamMembers in
                self?.teamMembers = newTeamMembers
            }
            .store(in: &cancellables)
    }
}

final class MockTeamMemberListDecorator: HTTPClient {
    private var mockHttpClient: MockHTTPClient
    
    init() {
        let mockData = MockHTTPClient.mockData(object: TeamMember.sampleMembers)
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
