//
//  ProfileAPI.swift
//  Created on 22/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class ProfileAPI: ProfileService {
    private var cancellable: AnyCancellable?
    
    // get user profile from backend
    func getProfile(completion: @escaping (ProfileModel.ProfileData) -> Void) {
        //get auth token
        guard let token = try? KeychainManager.getToken() else {
            return
        }
        print(token)
        
        //parallel request for profile and home
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.Users.user, token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(ProfileViewModel().getProfile()) }
            .sink { profile in
                completion(profile)
            }
    }
    
    // makes api call to update profile
    func updateProfile(
        updateProfileData: ProfileModel.ProfileData,
        completion: @escaping (ProfileModel.UpdateProfileResponseData, Bool) -> Void
    ) {
        //get auth token
        guard let token = try? KeychainManager.getToken() else {
            return
        }
        
        //encoded upload data
        guard let uploadData = try? JSONEncoder().encode(updateProfileData) else {
            return
        }
        
        // set default update profile response data
        let updateProfileResponseData = ProfileModel.UpdateProfileResponseData(message: "")
        
        //api call
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.Users.user, httpMethod: "PUT", uploadData: uploadData, token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(updateProfileResponseData) }
            .sink {
                var success = false
                if NetworkManager.responseCode == 200 {
                    success = true
                }
                completion($0, success)
        }
    }
    
}
