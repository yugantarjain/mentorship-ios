//
//  ProfileViewModelTests.swift
//  Created on 10/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import XCTest
@testable import mentorship_ios

class ProfileTests: XCTestCase {
    // sample profile data
    let sampleProfileData = ProfileModel.ProfileData(id: 100, email: "sampleTestEmail")
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
    
    func testGetProfileService() throws {
        // Profile Service
        let profileService: ProfileService = ProfileAPI(urlSession: urlSession)
        
        // Set mock data
        let mockData = try JSONEncoder().encode(sampleProfileData)
        
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        
        // Set expectation. Used to test async code.
        let expectation = XCTestExpectation(description: "response")
        
        // Make request to get profile
        profileService.getProfile { resp in
            XCTAssertEqual(resp, self.sampleProfileData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testUpdateProfileService() throws {
        // Profile Service
        let profileService: ProfileService = ProfileAPI(urlSession: urlSession)
        
        // Set mock json and data
        let mockJSON = ProfileModel.UpdateProfileResponseData(success: true, message: "response")
        let mockData = try JSONEncoder().encode(mockJSON)
        
        // Return data in mock request handler
        MockURLProtocol.requestHandler = { _ in
            return (HTTPURLResponse(), mockData)
        }
        
        // Set expectation. Used to test async code.
        let expectation = XCTestExpectation(description: "response")
        
        // Make request to get profile
        profileService.updateProfile(updateProfileData: self.sampleProfileData) { response in
            XCTAssertEqual(response.success, true)
            XCTAssertEqual(response.message, mockJSON.message)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    // MARK: - Method Tests
    
    func testSaveAndGetProfile() {
        let profileVM = ProfileViewModel()

        //save sample data
        profileVM.saveProfile(profile: sampleProfileData)
        
        //get profile data
        let getProfileData = profileVM.getProfile()
        
        //Test if save and get function works properly
        //sample data saved and data received using get should be equal.
        XCTAssertEqual(sampleProfileData, getProfileData)
    }
    
    func testEditProfileDataReceived() {
        let profileVM = ProfileViewModel()

        //prepare sample data
        let sampleData = ProfileModel.ProfileData(id: 100, name: nil, username: "username", email: "test@abc.com")
        
        //save sample data to profile
        //reason: getEditProfileData uses getProfile function to get stored data. Hence it will return this sample data now.
        profileVM.saveProfile(profile: sampleData)
        
        // get edit profile data
        let editProfileData = profileVM.getEditProfileData()
        
        //id and email should be unchanged
        XCTAssertEqual(editProfileData.id, sampleData.id)
        XCTAssertEqual(editProfileData.email, sampleData.email)
        
        //name should be empty string (""). nil values are converted to allow for safe force unwrapping
        XCTAssertEqual(editProfileData.name, "")
        
        //username should be nil. Username is made nil since it can't be updated. Otherwise, the backend call fails.
        XCTAssertEqual(editProfileData.username, nil)
    }
}
