//
//  SignUpViewModelTests.swift
//  Created on 10/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import XCTest
@testable import mentorship_ios

class SignUpTests: XCTestCase {
    //init sign up view model
    let signupVM = SignUpViewModel()
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
    
    func testSignUpService() throws {
        // Login Service
        let signUpService: SignUpService = SignUpAPI(urlSession: urlSession)
        
        // Set mock json and data
        let mockJSON = SignUpModel.SignUpResponseData(message: "test data")
        let mockData = try JSONEncoder().encode(mockJSON)

        // Return data in mock request handler
        MockURLProtocol.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        // Set expectation. Used to test async code.
        let expectation = XCTestExpectation(description: "response")
        
        // Set sign up data
        let signUpData = SignUpModel.SignUpUploadData(name: "testName", username: "test", password: "password", email: "test", tncChecked: true, needMentoring: false, availableToMentor: false)
        
        // Make login request and test response data. Confirm password same as password.
        signUpService.signUp(availabilityPickerSelection: 0, signUpData: signUpData, confirmPassword: "password") { resp in
            XCTAssertEqual(resp.message, mockJSON.message)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testNonMatchingPasswordSignUp() {
        //set sign up data
        let signUpData = SignUpModel.SignUpUploadData(name: "testName", username: "test", password: "password", email: "test", tncChecked: true, needMentoring: false, availableToMentor: false)

        // Call signup. Use mocking for safety (completion should be called before network request made).
        SignUpAPI(urlSession: urlSession).signUp(availabilityPickerSelection: 0, signUpData: signUpData, confirmPassword: "password2") { response in
            // Test
            XCTAssertEqual(response.message, LocalizableStringConstants.passwordsDoNotMatch)
        }
    }
    
    func testSignUpButtonDisabledState() {
        // MARK: - 1. When fields empty. Disabled state should be true.
        
        //set disabled state. Currently, data is empty.
        var signUpDisabledState = signupVM.signupDisabled
        
        //Test
        XCTAssertEqual(signUpDisabledState, true)
        
        // MARK: - 2. When fields filled. Disabled state should be false.

        //set sign up data and confirm password used by signupDisbaled property
        signupVM.signUpData = SignUpModel.SignUpUploadData(name: "testName", username: "test", password: "password", email: "test", tncChecked: true, needMentoring: false, availableToMentor: false)
        //confirm password different than normal password. However, this is allowed.
        signupVM.confirmPassword = "password-2"
        
        signUpDisabledState = signupVM.signupDisabled
        
        //Test
        XCTAssertEqual(signUpDisabledState, false)
        
        // MARK: - 3. When 'password' and 'confirm password' both empty (equal) and other fields filled. Disabled state should be true.
        signupVM.signUpData = SignUpModel.SignUpUploadData(name: "testName", username: "test", password: "", email: "test", tncChecked: true, needMentoring: false, availableToMentor: false)
        signupVM.confirmPassword = ""
        
        signUpDisabledState = signupVM.signupDisabled
        
        // empty passwords not allowed (though equal). Hence, button should be disabled.
        XCTAssertEqual(signUpDisabledState, true)
    }
}
