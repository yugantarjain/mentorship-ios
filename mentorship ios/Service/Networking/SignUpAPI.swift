//
//  SignUpAPI.swift
//  Created on 23/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class SignUpAPI: SignUpService {
    private var cancellable: AnyCancellable?
    var signUpResponseData = SignUpModel.SignUpResponseData(message: "")
    
    func signUp(
        availabilityPickerSelection: Int,
        signUpData: SignUpModel.SignUpUploadData,
        confirmPassword: String,
        completion: @escaping (SignUpModel.SignUpResponseData) -> Void
    ) {
        // make variable for sign up data
        var signUpData = signUpData
        
        //assign availability values as per picker selection
        if availabilityPickerSelection > 1 {
            signUpData.needMentoring = true
        }
        if availabilityPickerSelection != 2 {
            signUpData.availableToMentor = true
        }

        //check password fields
        if signUpData.password != confirmPassword {
            signUpResponseData.message = "Passwords do not match"
            completion(signUpResponseData)
            return
        }

        //encode upload data
        guard let uploadData = try? JSONEncoder().encode(signUpData) else {
            return
        }
        
        //api call
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.Users.signUp, httpMethod: "POST", uploadData: uploadData)
            .receive(on: RunLoop.main)
            .catch { _ in Just(SignUpNetworkModel(message: LocalizableStringConstants.networkErrorString)) }
            .sink {
                let signUpResponseData = SignUpModel.SignUpResponseData(message: $0.message)
                completion(signUpResponseData)
        }
    }
}

// MARK: Network Model
extension SignUpAPI {
    struct SignUpNetworkModel: Decodable {
        var message: String?
    }
}
