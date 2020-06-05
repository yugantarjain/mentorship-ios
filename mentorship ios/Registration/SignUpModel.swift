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
        let message: String?
    }
    
    @Published var signUpData = SignUpUploadData(name: "", username: "", password: "", email: "", terms_and_conditions_checked: false, need_mentoring: true, available_to_mentor: false)
    @Published var signUpResponseData = SignUpResponseData(message: "")
    private var cancellable: AnyCancellable?
    
    func signUp() {
        guard let uploadData = try? JSONEncoder().encode(signUpData) else {
            fatalError("sign up data unable to be encoded")
        }
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.signUp, httpMethod: "POST", uploadData: uploadData, decodeType: signUpResponseData)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.signUpResponseData) }
            .assign(to: \.signUpResponseData, on: self)
    }
    
}
