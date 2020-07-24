//
//  SettingsAPI.swift
//  Created on 24/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class SettingsAPI {
    private var cancellable: AnyCancellable?

    func deleteAccount(completion: @escaping (SettingsModel.DeleteAccountResponseData) -> Void) {
        //get token
        guard let token = try? KeychainManager.getToken() else {
            return
        }
        
        //api call
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.Users.user, httpMethod: "DELETE", token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(DeleteAccountNetworkModel(message: LocalizableStringConstants.networkErrorString)) }
            .sink {
                let success = NetworkManager.responseCode == 200
                let responseData = SettingsModel.DeleteAccountResponseData(message: $0.message, success: success)
                completion(responseData)
            }
    }
    
    struct DeleteAccountNetworkModel: Decodable {
        let message: String?
    }
}
