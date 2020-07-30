//
//  TaskCommentsModel.swift
//  Created on 28/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

class TaskCommentsModel {
    struct TaskCommentsResponse: Identifiable, Encodable {
        let id: Int?
        let userID: Int?
        let creationDate: Double?
        let comment: String?
    }
    
    struct PostCommentUploadData: Encodable {
        var comment: String
    }
    
    struct PostCommentResponse: Encodable {
        let message: String?
        let success: Bool
    }
}
