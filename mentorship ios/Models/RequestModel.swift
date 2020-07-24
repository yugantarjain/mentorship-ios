//
//  RequestModel.swift
//  Created on 24/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

struct RequestsList: Decodable {
    let sent: RequestStructures?
    let received: RequestStructures?
    
    struct RequestStructures: Decodable {
        let accepted: [RequestStructure]?
        let rejected: [RequestStructure]?
        let completed: [RequestStructure]?
        let cancelled: [RequestStructure]?
        let pending: [RequestStructure]?
    }
}

struct RequestStructure: Decodable, Identifiable {
    let id: Int?
    let mentor: Info?
    let mentee: Info?
    let endDate: Double?
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id, mentor, mentee, notes
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

struct RequestActionResponse: Decodable {
    let message: String?
}
