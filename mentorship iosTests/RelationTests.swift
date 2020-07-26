//
//  RelationTests.swift
//  Created on 26/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import XCTest
@testable import mentorship_ios

class RelationTests: XCTestCase {
    // custom urlsession for mock network calls
    var urlSession: URLSession!
    
    // MARK: - Setup and Tear Down

    override func setUpWithError() throws {
        // Set url session for mock networking
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: configuration)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Service tests
    
    func testGetCurrentRelationService() throws {
        // Service
        let relationService: RelationService = RelationAPI(urlSession: urlSession)
        
        // Set mock json and data
        let mockJSON = RequestStructure(id: 0, mentor: nil, mentee: nil, endDate: 100, notes: "notes")
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Return data form mock request handler
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        
        // Expectation. Used to test async code
        let expectation = XCTestExpectation(description: "response")
        
        relationService.fetchCurrentRelation { resp in
            XCTAssertEqual(resp.id, 0)
            XCTAssertEqual(resp.endDate, mockJSON.endDate)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchTasksService() throws {
        // Service
        let relationService: RelationService = RelationAPI(urlSession: urlSession)
        
        // Set mock json and data
        let mockJSON = [TaskStructure(id: 0, description: "test task", isDone: true, createdAt: 0, completedAt: 0)]
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Return data form mock request handler
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        
        // Expectation. Used to test async code
        let expectation = XCTestExpectation(description: "response")
        
        relationService.fetchTasks(id: 0) { resp, success in
            // test count
            XCTAssertEqual(resp.count, 1)
            // test data. Use both methods - using literal, using mock json
            XCTAssertEqual(resp.first?.id, 0)
            XCTAssertEqual(resp.first?.description, mockJSON.first?.description)
            // test success
            XCTAssertEqual(success, true)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testAddNewTaskService() throws {
        // Service
        let relationService: RelationService = RelationAPI(urlSession: urlSession)
        
        // Set mock json and data
        let mockJSON = RelationModel.ResponseData(message: "test", success: true)
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Return data form mock request handler
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        
        // Expectation. Used to test async code
        let expectation = XCTestExpectation(description: "response")
        // Make request and test response
        relationService.addNewTask(newTask: RelationModel.AddTaskData(description: "test add task"), relationID: 0) { resp in
            XCTAssertEqual(resp.message, mockJSON.message)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testMarkTaskAsCompleteService() throws {
        // Service
        let relationService: RelationService = RelationAPI(urlSession: urlSession)
        
        // Set mock json and data
        let mockJSON = RelationModel.ResponseData(message: "test", success: true)
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Return data form mock request handler
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        
        // Expectation. Used to test async code
        let expectation = XCTestExpectation(description: "response")
        
        relationService.markAsComplete(taskID: 0, relationID: 0) { resp in
            XCTAssertEqual(resp.message, mockJSON.message)
            XCTAssertEqual(resp.success, true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - RelationViewModel tests
    
    func testPersonNameAndType() {
        let relationVM = RelationViewModel()
        
        // set names of user and other member in relation
        let userName = "User"
        let otherName = "RelationMemberName"
        
        // set sample user profile
        let sampleUserProfile = ProfileModel.ProfileData(id: 0, name: userName, email: "")
        ProfileViewModel().saveProfile(profile: sampleUserProfile)
        
        // set sample current relation
        let sampleRelation = RequestStructure(
            id: 0,
            mentor: RequestStructure.Info(id: 0, userName: "", name: userName),
            mentee: RequestStructure.Info(id: 1, userName: "", name: otherName),
            endDate: 0,
            notes: "")
        
        // make sample relation the current relation in view model
        relationVM.currentRelation = sampleRelation
        
        // Test. Person name should be equal to otherName
        XCTAssertEqual(relationVM.personName, otherName)
        // Test. Person type should be mentee.
        XCTAssertEqual(relationVM.personType, LocalizableStringConstants.mentee)
    }
    
    func testHandleFetchedTasks() {
        let relationVM = RelationViewModel()

        // set sample tasks
        let sampleTasks = [
            TaskStructure(id: 0, description: "", isDone: true, createdAt: 0, completedAt: 0),
            TaskStructure(id: 1, description: "", isDone: false, createdAt: 0, completedAt: 0),
            TaskStructure(id: 2, description: "", isDone: true, createdAt: 0, completedAt: 0)
        ]
        
        // Test. Handle sample tasks. Success = true.
        relationVM.handleFetchedTasks(tasks: sampleTasks, success: true)
        XCTAssertEqual(relationVM.toDoTasks.count, 1)
        XCTAssertEqual(relationVM.doneTasks.count, 2)
        XCTAssertEqual(relationVM.toDoTasks.first?.id, 1)
        XCTAssertEqual(relationVM.doneTasks.first?.id, 0)
        XCTAssertEqual(relationVM.doneTasks.last?.id, 2)
        
        // Test. Handle sample tasks. Success = false.
        relationVM.handleFetchedTasks(tasks: sampleTasks, success: false)
        XCTAssertEqual(relationVM.showErrorAlert, true)
        XCTAssertEqual(relationVM.alertMessage, LocalizableStringConstants.operationFail)
    }
}
