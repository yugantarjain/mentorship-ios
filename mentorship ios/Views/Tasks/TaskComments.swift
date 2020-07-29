//
//  TaskComments.swift
//  Created on 15/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct TaskComments: View {
    let taskCommentsService: TaskCommentsService = TaskCommentsAPI()
    @EnvironmentObject var taskCommentsVM: TaskCommentsViewModel
    let taskID: Int
    let taskName: String
    
    func fetchComments() {
        taskCommentsService.fetchTaskComments(reqID: taskCommentsVM.reqID, taskID: taskID) { comments in
            self.taskCommentsVM.isLoading = false
            self.taskCommentsVM.taskCommentsResponse = comments
        }
    }
    
    func postComment() {
        self.taskCommentsService.postTaskComment(
            reqID: self.taskCommentsVM.reqID,
            taskID: self.taskID,
            commentData: self.taskCommentsVM.newComment
        ) { resp in
            self.fetchComments()
            self.taskCommentsVM.newComment.comment = ""
        }
    }
    
    func commentCell(comment: TaskCommentsModel.TaskCommentsResponse) -> some View {
        // Comment cell
        VStack(alignment: .leading, spacing: DesignConstants.Form.Spacing.minimalSpacing) {
            // Sender name and time
            HStack {
                Text(self.taskCommentsVM.getCommentAuthorName(authorID: comment.userID!))
                    .font(.headline)
                
                Text(DesignConstants.DateFormat.taskTime.string(from: Date(timeIntervalSince1970: comment.creationDate ?? 0)))
                    .font(.footnote)
            }
            // Comment
            Text(comment.comment ?? "")
        }
    }
    
    var body: some View {
        VStack {
            // List showing comments
            Form {
                // activity indicator, show when comments screen first accessed
                if self.taskCommentsVM.isLoading {
                    ActivityIndicator(isAnimating: .constant(true))
                }
                    // task comments
                else {
                    ForEach(taskCommentsVM.taskCommentsResponse) { comment in
                        self.commentCell(comment: comment)
                    }
                }
            }
            
            // Text field at bottom with send button
            HStack {
                // Text Field
                TextField("Type here", text: $taskCommentsVM.newComment.comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Send Button
                Button(LocalizableStringConstants.send) {
                    self.postComment()
                }
                .disabled(self.taskCommentsVM.sendButtonDisabled)
            }
            .padding(.horizontal)
            .modifier(KeyboardAware())
            
            // Spacer for bottom
            Spacer()
        }
        .navigationBarTitle("Task Comments")
        .onAppear {
            self.taskCommentsVM.isLoading = true
            self.fetchComments()
        }
    }
}

struct TaskComments_Previews: PreviewProvider {
    static var previews: some View {
        TaskComments(taskID: 0, taskName: "Test task")
    }
}
