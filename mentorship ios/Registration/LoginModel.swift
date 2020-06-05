//
//  LoginModel.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 05/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI
import Combine

struct LoginUploadData: Encodable {
    var username: String
    var password: String
}

struct LoginDataReceived: Decodable {
    let message: String?
    let access_token: String?
}

final class LoginModel: ObservableObject {
    @Published var loginUploadData = LoginUploadData(username: "", password: "")
    @Published var loginResponseData = LoginDataReceived(message: "initial message", access_token: "")
    private var cancellable: AnyCancellable?
    
    var loginDisabled: Bool {
        if self.loginUploadData.username.isEmpty || self.loginUploadData.password.isEmpty {
            return true
        }
        return false
    }
        
    func login() {
        guard let uploadData = try? JSONEncoder().encode(loginUploadData) else {
            fatalError("login data unable to be encoded")
        }
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.login, httpMethod: "POST", uploadData: uploadData, decodeType: loginResponseData)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.loginResponseData) }
            .assign(to: \.loginResponseData, on: self)
    }
}
