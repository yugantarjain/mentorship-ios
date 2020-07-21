//
//  SignUpScreenTests.swift
//  Created on 16/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import XCTest

class SignUpScreenTests: XCTestCase {
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
        // Go to sign up screen
        app.buttons["Signup"].tap()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
    }

    // Sign Up button should be disabled if even a single field is empty or tnc is unchecked.
    // This test tests all the cases.
    func testSignUpButtonWithEmptyFields() {
        // Sign Up button should be hittable
        XCTAssert(app.scrollViews.otherElements.buttons["Sign Up"].isHittable)
        
        // MARK: - Initial State. All fields empty.
        // Sign Up button should be disabled.
        XCTAssert(app.scrollViews.otherElements.buttons["Sign Up"].isEnabled == false)
        
        // MARK: - Name text field filled. Other fields empty.
        // Tap Name text field and fill some text
        app.scrollViews.otherElements.textFields["Name"].tap()
        app.scrollViews.otherElements.textFields["Name"].typeText("Test Name")
        // Sign Up button should be disabled.
        XCTAssert(app.scrollViews.otherElements.buttons["Sign Up"].isEnabled == false)
        
        // Return keyboard
        app.keyboards.buttons["Return"].tap()
        
        // MARK: - Check terms and conditions. Text fields still empty (except name)
        app.scrollViews.otherElements.switches["Terms and Conditions"].tap()
        // Terms and conditions toggle should be on.
        XCTAssertEqual(app.scrollViews.otherElements.switches["Terms and Conditions"].value as? String, "1")
        // Sign Up button should be disabled.
        XCTAssert(app.scrollViews.otherElements.buttons["Sign Up"].isEnabled == false)
    }
    
    // The sign up button should enable once all the fields are filled and tnc is checked.
    func testSignUpButtonWithFilledFields() {
        // MARK: - Filled fields. But tnc unchecked.
        // Text fields should be hittable. Check Name field for this purpose.
        XCTAssert(app.scrollViews.otherElements.textFields["Name"].isHittable)
        // Fill all text fields
        app.scrollViews.otherElements.textFields["Name"].tap()
        app.scrollViews.otherElements.textFields["Name"].typeText("Test")
        app.scrollViews.otherElements.textFields["Username"].tap()
        app.scrollViews.otherElements.textFields["Username"].typeText("Test")
        app.scrollViews.otherElements.textFields["Email"].tap()
        app.scrollViews.otherElements.textFields["Email"].typeText("Test")
        app.scrollViews.otherElements.secureTextFields["Password"].tap()
        app.scrollViews.otherElements.secureTextFields["Password"].typeText("Test")
        app.scrollViews.otherElements.secureTextFields["Confirm Password"].tap()
        app.scrollViews.otherElements.secureTextFields["Confirm Password"].typeText("Test")
        // Return keyboard
        app.keyboards.buttons["Return"].tap()
        // Sign Up button should be disabled.
        XCTAssert(app.scrollViews.otherElements.buttons["Sign Up"].isEnabled == false)
        
        // MARK: - Check terms and conditions. Now, all requirements fulfilled.
        app.scrollViews.otherElements.switches["Terms and Conditions"].tap()
        // Terms and conditions toggle should be on.
        XCTAssertEqual(app.scrollViews.otherElements.switches["Terms and Conditions"].value as? String, "1")
        // Sign Up button should be enabled!!
        XCTAssert(app.scrollViews.otherElements.buttons["Sign Up"].isEnabled)
    }
    
    // The 'x' button on navigation bar should dismiss sheet and login view should be visible.
    func testDismissXButton() {
        // 'x' button to dismiss should be visible
        XCTAssert(app.navigationBars["Sign Up"].buttons["x.circle.fill"].isHittable)
        // Press 'x' button
        app.navigationBars["Sign Up"].buttons["x.circle.fill"].tap()
        // Sheet should dismiss. Hence, login view should be visible.
        // Without this line, test fails. SwiftUI UI test inconsistency maybe.
        app.textFields["Username/Email"].tap()
        XCTAssert(app.buttons["Login"].isHittable)
    }

}
