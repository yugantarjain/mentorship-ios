//
//  TaskCommentsAPI.swift
//  Created on 28/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class TaskCommentsAPI: TaskCommentsService {
    private var cancellable: AnyCancellable?
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchTaskComments(
        reqID: Int,
        taskID: Int,
        completion: @escaping ([TaskCommentsModel.TaskCommentsResponse]) -> Void
    ) {
        //get auth token
        guard let token = try? KeychainManager.getToken() else {
            return
        }
        
        //api call
        cancellable = NetworkManager.callAPI(
            urlString: URLStringConstants.MentorshipRelation.getTaskComments(reqID: reqID, taskID: taskID),
            token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just([NetworkResponseModel]()) }
            .sink { comments in
                print(comments)
                var response = [TaskCommentsModel.TaskCommentsResponse]()
                for comment in comments {
                    response.append(.init(id: comment.id, userID: comment.userID, creationDate: comment.creationDate, comment: comment.comment))
                }
                completion(response)
        }
    }
    
    struct NetworkResponseModel: Decodable {
        let id: Int?
        let userID: Int?
        let creationDate: Double?
        let comment: String?
        
        enum CodingKeys: String, CodingKey {
            case id, comment
            case userID = "user_id"
            case creationDate = "creation_date"
        }
    }
}