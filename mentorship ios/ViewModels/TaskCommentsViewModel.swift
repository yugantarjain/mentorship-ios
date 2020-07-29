//
//  TaskCommentsViewModel.swift
//  Created on 28/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Combine

class TaskCommentsViewModel: ObservableObject {
    @Published var taskCommentsResponse = [TaskCommentsModel.TaskCommentsResponse]()
    @Published var newComment = ""
    @Published var isLoading = false
    let userID = ProfileViewModel().getProfile().id
    var reqName: String = ""
    var reqID: Int = -1
    
    func getCommentAuthorName(authorID: Int) -> String {
        if authorID == userID {
            return "You"
        } else {
            return reqName
        }
    }
}
