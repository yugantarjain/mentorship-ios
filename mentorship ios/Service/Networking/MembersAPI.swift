//
//  MembersAPI.swift
//  Created on 24/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class MembersAPI {
    private var cancellable: AnyCancellable?

    //Fetch Members
    func fetchMembers(pageToLoad: Int, perPage: Int = 20, completion: @escaping ([MembersModel.MembersResponseData], Bool) -> Void) {
        //get auth token
        guard let token = try? KeychainManager.getToken() else {
            return
        }

        // Debug comment: cache policy to be changed later to revalidateCache
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.Users.members(page: pageToLoad, perPage: perPage), token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just([MembersNetworkModel]()) }
            .sink {
                var membersResponse = [MembersModel.MembersResponseData]()
                for networkMember in $0 {
                    // set member
                    let member = MembersModel.MembersResponseData(
                        id: networkMember.id,
                        username: networkMember.username,
                        name: networkMember.name,
                        bio: networkMember.bio,
                        location: networkMember.location,
                        occupation: networkMember.occupation,
                        organization: networkMember.organization,
                        interests: networkMember.interests,
                        skills: networkMember.skills,
                        slackUsername: networkMember.slackUsername,
                        needMentoring: networkMember.needMentoring,
                        availableToMentor: networkMember.availableToMentor,
                        isAvailable: networkMember.isAvailable)
                    // append member to members response
                    membersResponse.append(member)
                }
                // if count less than per page limit, list is full.
                let membersListFull = $0.count < perPage
                completion(membersResponse, membersListFull)
        }
    }
    
    struct MembersNetworkModel: Decodable {
        let id: Int

        let username: String?
        let name: String?

        let bio: String?
        let location: String?
        let occupation: String?
        let organization: String?
        let interests: String?
        let skills: String?

        let slackUsername: String?
        let needMentoring: Bool?
        let availableToMentor: Bool?
        let isAvailable: Bool?

        enum CodingKeys: String, CodingKey {
            case id, username, name, bio, location, occupation, organization, interests, skills
            case slackUsername = "slack_username"
            case needMentoring = "need_mentoring"
            case availableToMentor = "available_to_mentor"
            case isAvailable = "is_available"
        }
    }
}
