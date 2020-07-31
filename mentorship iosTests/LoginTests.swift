//
//  LoginViewModelTests.swift
//  Created on 10/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import XCTest
@testable import mentorship_ios

class LoginTests: XCTestCase {
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
        urlSession = nil
        super.tearDown()
    }
    
    // MARK: - Service Tests
    
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
    
    // MARK: - ViewModel Tests

    func testLoginButtonDisabledState() {
        let loginVM = LoginViewModel()

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
    
    // MARK: - View Tests (Integration Tests)
    
    func testLoginActionInView() throws {
        // Login Service to inject in view for mock network calls
        let loginService: LoginService = LoginAPI(urlSession: urlSession)

        // View model for login view
        let loginVM = LoginViewModel()
        
        // Login View
        let loginView = Login(loginService: loginService, loginViewModel: loginVM)
        
        // Set mock json and data
        let mockJSON = LoginModel.LoginResponseData(message: "test message")
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        // loginVM should be in initial state
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(loginVM.loginResponseData.message, "")
        }
        
        // Perform login action
        loginView.login()
        
        // View model should be updated
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(loginVM.loginResponseData.message, mockJSON.message)
        }
    }

}
