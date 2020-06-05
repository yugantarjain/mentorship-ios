//
//  SignUpModel.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 05/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI
import Combine

final class SignUpModel: ObservableObject {
    //MARK: - Variables
    @Published var signUpData = SignUpUploadData(name: "", username: "", password: "", email: "", terms_and_conditions_checked: false, need_mentoring: true, available_to_mentor: false)
    @Published var signUpResponseData = SignUpResponseData(message: "frifgne ierfn erionfg io")
    @Published var confirmPassword: String = ""
    @Published var availabilityPickerSelection: Int = 2
    private var cancellable: AnyCancellable?

    var signupDisabled: Bool {
        if signUpData.name.isEmpty || signUpData.username.isEmpty || signUpData.email.isEmpty || signUpData.password.isEmpty || confirmPassword.isEmpty || !signUpData.terms_and_conditions_checked {
            return true
        } else {
            return false
        }
    }
    
    //MARK: - Main Function
    func signUp() {
        //assign availability values as per picker selection
        if self.availabilityPickerSelection > 1 {
            self.signUpData.need_mentoring = true
        }
        if self.availabilityPickerSelection != 2 {
            self.signUpData.available_to_mentor = true
        }
        
        //check password fields
        if self.signUpData.password != self.confirmPassword {
            self.signUpResponseData.message = "Passwords do not match"
            return
        }
        
        guard let uploadData = try? JSONEncoder().encode(signUpData) else {
            fatalError("sign up data unable to be encoded")
        }
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.signUp, httpMethod: "POST", uploadData: uploadData)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.signUpResponseData) }
            .assign(to: \.signUpResponseData, on: self)
    }
    
    //MARK: - Structures
    struct SignUpUploadData: Encodable {
        var name: String
        var username: String
        var password: String
        var email: String
        var terms_and_conditions_checked: Bool
        var need_mentoring: Bool
        var available_to_mentor: Bool
    }
    
    struct SignUpResponseData: Decodable {
        var message: String?
    }
}
