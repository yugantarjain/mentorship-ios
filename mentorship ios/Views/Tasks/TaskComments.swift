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
    
    func fetchComments() {
        taskCommentsService.fetchTaskComments(reqID: taskCommentsVM.reqID, taskID: taskID) { comments in
            self.taskCommentsVM.isLoading = false
            self.taskCommentsVM.taskCommentsResponse = comments
        }
    }
    
    var body: some View {
        VStack {
            // List showing comments
            List {
                if self.taskCommentsVM.isLoading {
                    ActivityIndicator(isAnimating: .constant(true))
                } else {
                    ForEach(taskCommentsVM.taskCommentsResponse) { comment in
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
                }
            }
            
            // Text field at bottom with send button
            HStack {
                // Text Field
                TextField("Type here", text: $taskCommentsVM.newComment.comment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // Send Button
                Button("Send") {
                    self.taskCommentsService.postTaskComment(
                        reqID: self.taskCommentsVM.reqID,
                        taskID: self.taskID,
                        commentData: self.taskCommentsVM.newComment
                    ) { resp in
                        self.fetchComments()
                        self.taskCommentsVM.newComment.comment = ""
                    }
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
        TaskComments(taskID: 0)
    }
}
