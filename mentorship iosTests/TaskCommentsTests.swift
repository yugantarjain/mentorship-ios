//
//  TaskCommentsTests.swift
//  Created on 30/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import XCTest
@testable import mentorship_ios

class TaskCommentsTests: XCTestCase {
    // custom urlsession for mock network calls
    var urlSession: URLSession!

    override func setUpWithError() throws {
        // Set url session for mock networking
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }

    override func tearDownWithError() throws {
        urlSession = nil
        super.tearDown()
    }

    // MARK: - Service Tests
    
    func testFetchComments() throws {
        let taskCommentsService: TaskCommentsService = TaskCommentsAPI(urlSession: urlSession)
        
        // Set mock json and data
        let mockJSON: [TaskCommentsModel.TaskCommentsResponse] = [
        .init(id: nil, userID: nil, creationDate: nil, comment: "Task 1"),
        .init(id: nil, userID: nil, creationDate: nil, comment: nil)
        ]
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Return data from mock handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        // Expectation
        let expectation = XCTestExpectation(description: "response")
        taskCommentsService.fetchTaskComments(reqID: 0, taskID: 0) { resp in
            XCTAssertEqual(resp.count, 2)
            XCTAssertEqual(resp[0].comment, mockJSON[0].comment)
            XCTAssertEqual(resp[1].id, nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testPostTaskComment() throws {
        let taskCommentsService: TaskCommentsService = TaskCommentsAPI(urlSession: urlSession)
        
        // Set mock json and data
        let mockJSON = TaskCommentsModel.PostCommentResponse(message: "test", success: false)
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Return data from mock handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        // Expectation
        let expectation = XCTestExpectation(description: "response")
        taskCommentsService.postTaskComment(reqID: 0, taskID: 0, commentData: .init(comment: "comment")) { resp in
            XCTAssertEqual(resp.message, mockJSON.message)
            XCTAssertEqual(resp.success, false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - View Model Tests
    
    func testSendButtonDisabledState() {
        let taskCommentsVM = TaskCommentsViewModel()
        
        // MARK: - 1. Comment is empty right now. Button should be disabled.
        XCTAssertEqual(taskCommentsVM.sendButtonDisabled, true)
        
        // MARK: - 2. Comment not empty. Button should be enabled.
        taskCommentsVM.newComment.comment = "test"
        XCTAssertEqual(taskCommentsVM.sendButtonDisabled, false)
    }
    
    func testGetAuthorName() {
        let taskCommentsVM = TaskCommentsViewModel()

        // ID same as user. Should return "You"
        XCTAssertEqual(taskCommentsVM.getCommentAuthorName(authorID: taskCommentsVM.userID), "You")
        
        // ID different that user. Should return name of member
        taskCommentsVM.reqName = "testName"
        XCTAssertEqual(taskCommentsVM.getCommentAuthorName(authorID: taskCommentsVM.userID + 1), "testName")
    }

}
