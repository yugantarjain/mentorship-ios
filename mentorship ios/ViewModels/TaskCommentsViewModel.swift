//
//  TaskCommentsViewModel.swift
//  Created on 28/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Combine

class TaskCommentsViewModel: ObservableObject {
    @Published var taskCommentsResponse = [TaskCommentsModel.TaskCommentsResponse]()
    @Published var newComment = TaskCommentsModel.PostCommentUploadData(comment: "")
    @Published var isLoading = false
    @Published var showingEarlier = false
    let userID = ProfileViewModel().getProfile().id
    let latestCommentsLimit = 4
    var reqName: String = ""
    var reqID: Int = -1
    
    var tasksMoreThanLimit: Bool {
        return taskCommentsResponse.count > latestCommentsLimit
    }
    
    var commentsToShow: [TaskCommentsModel.TaskCommentsResponse] {
        if showingEarlier {
            return taskCommentsResponse
        } else {
            return Array(taskCommentsResponse.suffix(4))
        }
    }
    
    var sendButtonDisabled: Bool {
        return newComment.comment.isEmpty
    }
    
    func getCommentAuthorName(authorID: Int) -> String {
        if authorID == userID {
            return "You"
        } else {
            return reqName
        }
    }
}
