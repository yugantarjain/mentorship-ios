//
//  HomeTests.swift
//  Created on 26/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import XCTest
@testable import mentorship_ios

class HomeTests: XCTestCase {
    // custom urlsession for mock network calls
    var urlSession: URLSession!

    override func setUpWithError() throws {
        // Set url session for mock networking
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // BUG - response always nil (line 44 - print(resp))
    func testHomeService() throws {
        // Home Service
        let homeService: HomeService = HomeAPI(urlSession: urlSession)

        // Set mock json and data
        let mockJSON = HomeModel.HomeResponseData(asMentor: nil, asMentee: RequestsList(sent: nil, received: nil), tasksToDo: [TaskStructure(id: 0, description: "", isDone: true, createdAt: 0, completedAt: 0)], tasksDone: [TaskStructure]())
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        // Set expectation. Used to test async code.
        let expectation = XCTestExpectation(description: "response")
        
        // Make fetch dashboard request and test response data.
        homeService.fetchDashboard { resp in
            print(resp)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
