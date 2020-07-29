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
    
    var body: some View {
        VStack {
            // List showing comments
            List {
                if self.taskCommentsVM.isLoading {
                    ActivityIndicator(isAnimating: .constant(true))
                } else {
                    ForEach(taskCommentsVM.taskCommentsResponse) { comment in
                        // Comment cell
                        VStack(alignment: .leading, spacing: DesignConstants.Spacing.smallSpacing) {
                            // Sender name and time
                            HStack {
                                Text(self.taskCommentsVM.getCommentAuthorName(authorID: comment.id ?? -1))
                                    .font(.headline)
                                
                                Text(DesignConstants.DateFormat.taskTime.string(from: Date(timeIntervalSince1970: comment.creationDate ?? 0)))
                                    .font(.subheadline)
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
                TextField("Type here", text: $taskCommentsVM.newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // Send Button
                Button("Send") {
                }
            }
            .padding(.horizontal)
            .modifier(KeyboardAware())
            
            // Spacer for bottom
            Spacer()
        }
        .navigationBarTitle("Task Comments")
        .onAppear {
            self.taskCommentsVM.isLoading = true
            self.taskCommentsService.fetchTaskComments(reqID: self.taskCommentsVM.reqID, taskID: self.taskID) { comments in
                self.taskCommentsVM.isLoading = false
                self.taskCommentsVM.taskCommentsResponse = comments
            }
        }
    }
}

struct TaskComments_Previews: PreviewProvider {
    static var previews: some View {
        TaskComments(taskID: 0)
    }
}
