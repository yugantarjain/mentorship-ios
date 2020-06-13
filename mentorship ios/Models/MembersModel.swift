//
//  MembersModel.swift
//  Created on 07/06/20.
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI
import Combine

final class MembersModel: ObservableObject {

    // MARK: - Variables
    @Published var membersResponseData = [MembersResponseData]()
    @Published var sendRequestResponseData = SendRequestResponseData(message: "")
    @Published var inActivity = false
    private var cancellable: AnyCancellable?

    // MARK: - Functions
    func fetchMembers() {
        guard let token = try? KeychainManager.readKeychain() else {
            return
        }

        self.inActivity = true

        // Debug comment: cache policy to be changed later to revalidateCache
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.Users.members, httpMethod: "GET", token: token, cachePolicy: .returnCacheDataElseLoad)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.membersResponseData) }
            .sink(receiveCompletion: { completion in
                if completion == .finished {
                    self.inActivity = false
                }
            }, receiveValue: { value in
                self.membersResponseData = value
            })
    }

    func availabilityString(canBeMentee: Bool, canBeMentor: Bool) -> String {
        if canBeMentor && canBeMentor {
            return "Available to be a Mentor or Mentee"
        } else if canBeMentee {
            return "Available to be a Mentee"
        } else if canBeMentor {
            return "Availabe to be a Mentor"
        } else {
            return "Not available"
        }
    }

    func skillsString(skills: String) -> String {
        return "Skills: \(skills)"
    }
    
    func sendRequest(menteeID: Int, mentorID: Int, endDate: Int, notes: String) {
        //token
        guard let token = try? KeychainManager.readKeychain() else {
            return
        }
        
        //upload data
        let requestData = SendRequestUploadData(mentorID: mentorID, menteeID: menteeID, endDate: endDate, notes: notes)
        print(requestData)
        guard let uploadData = try? JSONEncoder().encode(requestData) else {
            return
        }
         
        //activity indicator
        self.inActivity = true
        
        //api call
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.MentorshipRelation.sendRequest, httpMethod: "POST", uploadData: uploadData, token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.sendRequestResponseData) }
            .sink(receiveCompletion: { _ in
                self.inActivity = false
            }, receiveValue: { value in
                self.sendRequestResponseData = value
            })
    }

    // MARK: - Structures
    struct MembersResponseData: Decodable, Identifiable {
        let id: Int?

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
    
    struct SendRequestUploadData: Encodable {
        var mentorID: Int
        var menteeID: Int
        var endDate: Int
        var notes: String
        
        enum CodingKeys: String, CodingKey {
            case notes
            case mentorID = "mentor_id"
            case menteeID = "mentee_id"
            case endDate = "end_date"
        }
    }
    
    struct SendRequestResponseData: Decodable {
        let message: String?
    }

}
