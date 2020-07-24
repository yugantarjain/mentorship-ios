//
//  RequestModel.swift
//  Created on 24/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

struct RequestsList: Decodable {
    let sent: Sent?
    struct Sent: Decodable {
        let accepted: [RequestStructure]?
        let rejected: [RequestStructure]?
        let completed: [RequestStructure]?
        let cancelled: [RequestStructure]?
        let pending: [RequestStructure]?
    }
    let received: Received?
    struct Received: Decodable {
        let accepted: [RequestStructure]?
        let rejected: [RequestStructure]?
        let completed: [RequestStructure]?
        let cancelled: [RequestStructure]?
        let pending: [RequestStructure]?
    }
}

struct RequestStructure: Decodable, Identifiable {
    let id: Int?
    let actionUserID: Int?
    let mentor: Info?
    let mentee: Info?
    let acceptDate: Double?
    let startDate: Double?
    let endDate: Double?
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id, mentor, mentee, notes
        case actionUserID = "action_user_id"
        case acceptDate = "accept_date"
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    //info struct for mentor/mentee information
    struct Info: Decodable {
        let id: Int?
        let userName: String?
        let name: String?
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case userName = "user_name"
        }
    }
}
