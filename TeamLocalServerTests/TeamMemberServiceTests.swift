//
//  TeamMemberServiceTests.swift
//  TeamLocalServerTests
//
//  Created by Snow Lukin on 05.12.2023.
//

import XCTest
import Combine
@testable import TeamLocalServer

final class TeamMemberServiceTests: XCTestCase {
    
    private var httpClient: MockHTTPClient!
    private var service: TeamMemberService!
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        httpClient = MockHTTPClient()
        service = TeamMemberService(httpClient: httpClient)
    }

    override func tearDownWithError() throws {
        cancellables = []
        httpClient = nil
        service = nil
    }
    
    func testLoadAllSuccess() throws {
        
        let sampleTeamMembers = TeamMember.sampleMembers
        let encoder = JSONEncoder.teamMemberEncoder()
        
        // Creating mock response
        let mockData = try encoder.encode(sampleTeamMembers)
        let mockResponse = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
        let httpClient = MockHTTPClient()
        httpClient.response = (mockData, mockResponse)
        
        // Service with mock http client
        let service = TeamMemberService(httpClient: httpClient)
        
        // Define expectation
        let expectation = XCTestExpectation(description: "Load all team members successfully")
        let expectedCount = TeamMember.sampleMembers.count
        
        // Call the service
        service.loadAll()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
            }, receiveValue: { teamMembers in
                // Assert that we received the expected team members
                XCTAssertEqual(teamMembers.count, expectedCount)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Wait for expectations
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadAllFailure() throws {
        let mockError = URLError(.timedOut)
        httpClient.error = mockError
        
        let expectation = XCTestExpectation(description: "Load all team members fails")

        service.loadAll()
            .sink(receiveCompletion: { completion in
                if case .failure(let error as URLError) = completion {
                    XCTAssertEqual(error.code, mockError.code)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected URLError")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but succeeded")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadByIDSuccess() throws {
        let sampleMember = TeamMember.sampleMembers.first!
        let encoder = JSONEncoder.teamMemberEncoder()
        let mockData = try encoder.encode(sampleMember)
        let mockResponse = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
        httpClient.response = (mockData, mockResponse)
        
        let expectation = XCTestExpectation(description: "Load team member by ID successfully")

        service.load(by: sampleMember.id.withDefaultValue(1))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
            }, receiveValue: { teamMember in
                // We dont check hiring date here because of specific way of serialization
                XCTAssertEqual(teamMember.id, sampleMember.id)
                XCTAssertEqual(teamMember.name, sampleMember.name)
                XCTAssertEqual(teamMember.surname, sampleMember.surname)
                XCTAssertEqual(teamMember.middleName, sampleMember.middleName)
                XCTAssertEqual(teamMember.role, sampleMember.role)
                XCTAssertEqual(teamMember.specialization, sampleMember.specialization)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadByIDFailure() throws {
        let mockError = URLError(.cannotFindHost)
        httpClient.error = mockError
        
        let expectation = XCTestExpectation(description: "Fail to load team member by ID")

        service.load(by: -1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error as URLError) = completion {
                    XCTAssertEqual(error.code, mockError.code)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected URLError")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but succeeded")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testCreateMemberSuccess() throws {
        let newMember = TeamMember.sampleMember
        let encoder = JSONEncoder.teamMemberEncoder()
        let mockData = try encoder.encode(newMember)
        let mockResponse = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                           statusCode: 201,
                                           httpVersion: nil,
                                           headerFields: nil)!
        httpClient.response = (mockData, mockResponse)
        
        let expectation = XCTestExpectation(description: "Create team member successfully")

        service.create(newMember)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
            }, receiveValue: { createdMember in
                // We dont check hiring date here because of specific way of serialization
                XCTAssertEqual(createdMember.id, newMember.id)
                XCTAssertEqual(createdMember.name, newMember.name)
                XCTAssertEqual(createdMember.surname, newMember.surname)
                XCTAssertEqual(createdMember.middleName, newMember.middleName)
                XCTAssertEqual(createdMember.role, newMember.role)
                XCTAssertEqual(createdMember.specialization, newMember.specialization)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testCreateMemberFailure() throws {
        let newMember = TeamMember.sampleMember
        let mockError = URLError(.notConnectedToInternet)
        httpClient.error = mockError
        
        let expectation = XCTestExpectation(description: "Fail to create team member")

        service.create(newMember)
            .sink(receiveCompletion: { completion in
                if case .failure(let error as URLError) = completion {
                    XCTAssertEqual(error.code, mockError.code)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected URLError")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but succeeded")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateMemberSuccess() throws {
        let updatedMember = TeamMember(id: 0, name: "test1", surname: "test2", middleName: "test3", role: "test4", specialization: "test5", hiringDate: nil)
        let encoder = JSONEncoder.teamMemberEncoder()
        let mockData = try encoder.encode(updatedMember)
        let mockResponse = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
        httpClient.response = (mockData, mockResponse)
        
        let expectation = XCTestExpectation(description: "Update team member successfully")

        service.update(updatedMember)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
            }, receiveValue: { teamMember in
                // We dont check hiring date here because of specific way of serialization
                XCTAssertEqual(teamMember.id, updatedMember.id)
                XCTAssertEqual(teamMember.name, updatedMember.name)
                XCTAssertEqual(teamMember.surname, updatedMember.surname)
                XCTAssertEqual(teamMember.middleName, updatedMember.middleName)
                XCTAssertEqual(teamMember.role, updatedMember.role)
                XCTAssertEqual(teamMember.specialization, updatedMember.specialization)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateMemberFailure() throws {
        let memberToUpdate = TeamMember.sampleMember
        let mockError = URLError(.networkConnectionLost)
        httpClient.error = mockError
        
        let expectation = XCTestExpectation(description: "Update team member fails")

        service.update(memberToUpdate)
            .sink(receiveCompletion: { completion in
                if case .failure(let error as URLError) = completion {
                    XCTAssertEqual(error.code, mockError.code)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected URLError")
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but succeeded")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDeleteMemberByIDSuccess() throws {
        let mockResponse = HTTPURLResponse(url: URL(string: "http://localhost:8080")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
        httpClient.response = (Data(), mockResponse)
        
        let expectation = XCTestExpectation(description: "Delete team member by ID successfully")

        service.delete(by: 1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Request failed with error: \(error)")
                }
            }, receiveValue: {
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testDeleteMemberByIDFailure() throws {
        let mockError = URLError(.cannotConnectToHost)
        httpClient.error = mockError
        
        let expectation = XCTestExpectation(description: "Fail to delete team member by ID")

        service.delete(by: -1)
            .sink(receiveCompletion: { completion in
                if case .failure(let error as URLError) = completion {
                    XCTAssertEqual(error.code, mockError.code)
                    expectation.fulfill()
                } else {
                    XCTFail("Expected URLError")
                }
            }, receiveValue: {
                XCTFail("Expected failure, but succeeded")
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
