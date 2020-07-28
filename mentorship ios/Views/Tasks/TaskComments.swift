//
//  TaskComments.swift
//  Created on 15/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct TaskComments: View {
    let taskCommentsService: TaskCommentsService = TaskCommentsAPI()
    @ObservedObject var taskCommentsViewModel = TaskCommentsViewModel()
    let taskID: Int
    let reqID: Int
    let reqName: String
    let userID = ProfileViewModel().getProfile().id
    
    func commentAuthorName(authorID: Int) -> String {
        if authorID == userID {
            return "You"
        } else {
            return reqName
        }
    }
    
    var body: some View {
        VStack {
            // List showing comments
            List(taskCommentsViewModel.taskCommentsResponse) { comment in
                // Comment cell
                VStack(alignment: .leading, spacing: DesignConstants.Spacing.minimalSpacing) {
                    // Sender name and time
                    HStack {
                        Text(self.commentAuthorName(authorID: comment.id ?? -1))
                            .font(.headline)
                        Spacer()
                        Text(DesignConstants.DateFormat.taskTime.string(from: Date(timeIntervalSince1970: comment.creationDate ?? 0)))
                            .font(.subheadline)
                    }
                    // Comment
                    Text(comment.comment ?? "")
                }
            }
            
            // Text field at bottom with send button
            HStack {
                // Text Field
                TextField("Type here", text: $taskCommentsViewModel.newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // Send Button
                Button("Send") {
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("Task Comments")
        .onAppear {
            self.taskCommentsService.fetchTaskComments(reqID: self.reqID, taskID: self.taskID) { comments in
                self.taskCommentsViewModel.taskCommentsResponse = comments
            }
        }
    }
}

struct TaskComments_Previews: PreviewProvider {
    static var previews: some View {
        TaskComments(taskID: 0, reqID: 0, reqName: "")
    }
}
