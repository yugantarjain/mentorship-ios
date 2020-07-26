//
//  SettingsTests.swift
//  Created on 26/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import XCTest
@testable import mentorship_ios

class SettingsTests: XCTestCase {
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
    
    // MARK: - Service Tests
    
    func testDeleteAccountService() throws {
        let settingsService: SettingsService = SettingsAPI(urlSession: urlSession)
        
        // Set mock json and data
        let mockJSON = SettingsModel.DeleteAccountResponseData(message: "test", success: true)
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Return data form mock request handler
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        
        // Expectation. Used to test async code.
        let expectation = XCTestExpectation(description: "response")
        settingsService.deleteAccount { resp in
            XCTAssertEqual(resp.message, mockJSON.message)
            XCTAssertEqual(resp.success, true)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testChangePasswordService() throws {
        let settingsService: SettingsService = SettingsAPI(urlSession: urlSession)

        // Set mock json and data
        let mockJSON = ChangePasswordModel.ChangePasswordResponseData(message: "test", success: true)
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Return data form mock request handler
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        
        // MARK: Confirm password not equal to new password.
        
        // Expectation. Used to test async code.
        let expectation = XCTestExpectation(description: "response1")
        settingsService.changePassword(
            changePasswordData: ChangePasswordModel.ChangePasswordUploadData(currentPassword: "test", newPassword: "abcd"),
            confirmPassword: "ab") { resp in
                XCTAssertEqual(resp.message, LocalizableStringConstants.passwordsDoNotMatch)
                XCTAssertEqual(resp.success, false)
                expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        // MARK: Confirm password not equal to new password.
        
        // Expectation. Used to test async code.
        let expectation2 = XCTestExpectation(description: "response2")
        settingsService.changePassword(
            changePasswordData: ChangePasswordModel.ChangePasswordUploadData(currentPassword: "test", newPassword: "abcd"),
            confirmPassword: "abcd") { resp in
                XCTAssertEqual(resp.message, mockJSON.message)
                expectation2.fulfill()
        }
        wait(for: [expectation2], timeout: 1)
    }
}
