//
//  mentorship_iosTests.swift
//  Created on 30/05/20.
//  Created for AnitaB.org Mentorship-iOS
//

import XCTest
@testable import mentorship_ios

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
    }
}


class MentorshipTests: XCTestCase {
    var urlSession: URLSession!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequestAction() throws {
        // Set mock json for server response
        let mockJSON = ResponseMessage(message: "response message")
        // Create mock data from mock json
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Use mock protocol, and return mock data and url response from handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        // Init API Class with mock testing session
        let requestActionAPI = RelationRequestActionAPI(urlSession: urlSession)
        
        // Init expectation (used to test async code)
        let expectation = XCTestExpectation(description: "response")

        // mock api call and test in handler
        requestActionAPI.actOnPendingRequest(action: .accept, reqID: 0) {
            XCTAssertEqual($0.message, mockJSON.message)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
