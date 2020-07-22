//
//  HomeModel.swift
//  Created on 12/06/20.
//  Created for AnitaB.org Mentorship-iOS
//

class HomeModel {
    
    // MARK: - Structures
    struct HomeResponseData: Decodable {
        let asMentor: RequestsList?
        let asMentee: RequestsList?
        
        let tasksToDo: [TaskStructure]?
        let tasksDone: [TaskStructure]?
        
        enum CodingKeys: String, CodingKey {
            case asMentor = "as_mentor"
            case asMentee = "as_mentee"
            case tasksToDo = "tasks_todo"
            case tasksDone = "tasks_done"
        }
        
        //Nested structs
        
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
    }
    
    enum UserType {
        case mentee, mentor
    }
    
}

// MARK: - API
extension HomeModel.HomeResponseData {
    func mapTo(viewModel: HomeViewModel) {
        viewModel.relationsListData.relationCount = updateCount(homeData: self)
        viewModel.homeResponseData = self
    }
    
    func updateCount(homeData: Self) -> [Int] {
        var pendingCount = homeData.asMentee?.sent?.pending?.count ?? 0
        pendingCount += homeData.asMentee?.received?.pending?.count ?? 0
        pendingCount += homeData.asMentor?.sent?.pending?.count ?? 0
        pendingCount += homeData.asMentor?.received?.pending?.count ?? 0
        
        var acceptedCount = homeData.asMentee?.sent?.accepted?.count ?? 0
        acceptedCount += homeData.asMentee?.received?.accepted?.count ?? 0
        acceptedCount += homeData.asMentor?.sent?.accepted?.count ?? 0
        acceptedCount += homeData.asMentor?.received?.accepted?.count ?? 0
        
        var rejectedCount = homeData.asMentee?.sent?.rejected?.count ?? 0
        rejectedCount += homeData.asMentee?.received?.rejected?.count ?? 0
        rejectedCount += homeData.asMentor?.sent?.rejected?.count ?? 0
        rejectedCount += homeData.asMentor?.received?.rejected?.count ?? 0
        
        var cancelledCount = homeData.asMentee?.sent?.cancelled?.count ?? 0
        cancelledCount += homeData.asMentee?.received?.cancelled?.count ?? 0
        cancelledCount += homeData.asMentor?.sent?.cancelled?.count ?? 0
        cancelledCount += homeData.asMentor?.received?.cancelled?.count ?? 0
        
        var completedCount = homeData.asMentee?.sent?.completed?.count ?? 0
        completedCount += homeData.asMentee?.received?.completed?.count ?? 0
        completedCount += homeData.asMentor?.sent?.completed?.count ?? 0
        completedCount += homeData.asMentor?.received?.completed?.count ?? 0
        
        return [pendingCount, acceptedCount, rejectedCount, cancelledCount, completedCount]
    }
}
