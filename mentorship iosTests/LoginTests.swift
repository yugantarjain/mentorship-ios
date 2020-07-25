//
//  LoginViewModelTests.swift
//  Created on 10/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import XCTest
@testable import mentorship_ios

class LoginViewModelTests: XCTestCase {
    //init sign up view model
    let loginVM = LoginViewModel()
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
    
    func testLoginService() throws {
        // Login Service
        let loginService: LoginService = LoginAPI(urlSession: urlSession)
        
        // Set mock json and data
        let mockJSON = LoginModel.LoginResponseData(message: "test message")
        let mockData = try JSONEncoder().encode(mockJSON)

        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        // Set expectation. Used to test async code.
        let expectation = XCTestExpectation(description: "response")
        // Make login request and test response data.
        loginService.login(loginData: LoginModel.LoginUploadData(username: "abcd", password: "abcd")) { resp in
            XCTAssertEqual(resp.message, mockJSON.message)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
    }

    func testLoginButtonDisabledState() {
        // MARK: - 1. When fields empty. Disabled state should be true.
        
        //set disabled state. Currently, data is empty.
        var loginDisabledState = loginVM.loginDisabled
        
        //Test
        XCTAssertEqual(loginDisabledState, true)
        
        // MARK: - 2. When one filed filled and one empty. Disabled state should be true
        loginVM.loginData = LoginModel.LoginUploadData(username: "username", password: "")
        
        loginDisabledState = loginVM.loginDisabled

        //Test
        XCTAssertEqual(loginDisabledState, true)
        
        // MARK: - 3. When all fields filled. Disabled state should be false.
        loginVM.loginData = LoginModel.LoginUploadData(username: "username", password: "password")
        
        loginDisabledState = loginVM.loginDisabled
        
        //Test
        XCTAssertEqual(loginDisabledState, false)
    }

}
