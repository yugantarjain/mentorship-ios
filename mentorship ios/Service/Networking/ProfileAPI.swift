//
//  ProfileAPI.swift
//  Created on 22/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class ProfileAPI: ProfileService {
    private var cancellable: AnyCancellable?
    let currentProfile = ProfileViewModel().getProfile()
    
    func getProfile(completion: @escaping (ProfileModel.ProfileData) -> Void) {
        //get auth token
        guard let token = try? KeychainManager.getToken() else {
            return
        }
        print(token)
        
        //parallel request for profile and home
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.Users.user, token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.currentProfile) }
            .sink { profile in
                completion(profile)
            }
    }
    
}
