//
//  TaskCommentsViewModel.swift
//  Created on 28/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Combine

class TaskCommentsViewModel: ObservableObject {
    @Published var taskCommentsResponse = [TaskCommentsModel.TaskCommentsResponse]()
    @Published var newComment = ""
}
