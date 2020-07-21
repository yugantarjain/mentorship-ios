//
//  LoginScreenTests.swift
//  Created on 16/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import XCTest
import Foundation

class LoginScreenTests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        // Makes sure we're on the login screen. Changes userdefault bool value for isLoggedIn.
        app.launchArguments += ["-isLoggedIn", "NO"]
        // Launch
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }

    func testLoginButtonWithEmptyFields() {
        // Login Button should be hittable
        XCTAssert(app.buttons["Login"].isHittable)
        
        // Initial state. Fields empty. Login button should be disabled.
        XCTAssert(app.buttons["Login"].isEnabled == false)
    }
    
    func testLoginButtonWithFilledFields() {
        // Tap on username text field and enter text
        app.textFields["Username/Email"].tap()
        app.textFields["Username/Email"].typeText("Test Username")
        
        // Tap on password field and enter text
        app.secureTextFields["Password"].tap()
        app.secureTextFields["Password"].typeText("Test Password")
        
        // Fields filled. The login button should be enabled now.
        XCTAssert(app.buttons["Login"].isEnabled)
    }
    
    func testSignUpButton() {
        // Sign Up button should be hittable/visible
        XCTAssert(app.buttons["Signup"].isHittable)
        
        // Tap on Sign Up button
        app.buttons["Signup"].tap()
        
        // Sign Up view should be visible now. Navigation bar should have Sign Up title.
        XCTAssert(app.navigationBars["Sign Up"].isHittable)
    }

}
