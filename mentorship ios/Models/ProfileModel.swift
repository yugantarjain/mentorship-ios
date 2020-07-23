//
//  ProfileModel.swift
//  Created on 12/06/20.
//  Created for AnitaB.org Mentorship-iOS
//

final class ProfileModel {

    // MARK: - Structures
    struct ProfileData: Codable, ProfileProperties {
        let id: Int
        var name: String?
        var username: String?
        let email: String?
        var bio: String?
        var location: String?
        var occupation: String?
        var organization: String?
        var slackUsername: String?
        var skills: String?
        var interests: String?
        var needMentoring: Bool?
        var availableToMentor: Bool?

        enum CodingKeys: String, CodingKey {
            case id, name, username, email, bio, location, occupation, organization, skills, interests
            case slackUsername = "slack_username"
            case needMentoring = "need_mentoring"
            case availableToMentor = "available_to_mentor"
        }
    }
    
    struct UpdateProfileResponseData: Decodable {
        let message: String?
    }

}

// MARK: - API
extension ProfileModel.ProfileData {
    func mapTo(viewModel: HomeViewModel) {
        viewModel.profileData = self
    }
}

extension ProfileModel.UpdateProfileResponseData {
    func mapTo(viewModel: ProfileViewModel) {
        viewModel.updateProfileResponseData = self
    }
}
