//
//  ProfileModel.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 12/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI
import Combine

final class ProfileModel: ObservableObject {
    
    // MARK: - Variables
    var profileData = ProfileData(id: 0, name: "", username: "", email: "", bio: "", location: "", occupation: "", organization: "", slack_username: "", skills: "", interests: "", need_mentoring: false, available_to_mentor: false)

    // MARK: - Functions
    func saveProfile(profile: ProfileData) {
        guard let profileData = try? JSONEncoder().encode(profile) else {
            return
        }
        UserDefaults.standard.set(profileData, forKey: UserDefaultsConstants.profile)
    }
    
    func getProfile() -> ProfileData {
        let profileData = UserDefaults.standard.data(forKey: UserDefaultsConstants.profile)
        guard let profile = try? JSONDecoder().decode(ProfileData.self, from: profileData!) else {
            return self.profileData
        }
        return profile
    }

    // MARK: - Structures
    struct ProfileData: Codable {
        let id: Int
        let name: String?
        let username: String?
        let email: String?
        let bio: String?
        let location: String?
        let occupation: String?
        let organization: String?
        let slack_username: String?
        let skills: String?
        let interests: String?
        let need_mentoring: Bool?
        let available_to_mentor: Bool?
    }
    
}
