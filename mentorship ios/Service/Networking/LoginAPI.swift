//
//  LoginAPI.swift
//  Created on 23/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class LoginAPI: LoginService {
    private var cancellable: AnyCancellable?
    var loginResponseData = LoginModel.LoginResponseData(message: "", accessToken: "")
    
    func login(
        loginData: LoginModel.LoginUploadData,
        completion: @escaping (LoginModel.LoginResponseData) -> Void
    ) {
        // encode upload data
        guard let uploadData = try? JSONEncoder().encode(loginData) else {
            return
        }
        
        // make network request
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.Users.login, httpMethod: "POST", uploadData: uploadData)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.loginResponseData) }
            .sink {
                completion($0)
        }
    }
}
