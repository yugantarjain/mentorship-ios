//
//  TaskCommentCell.swift
//  Created on 07/08/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct TaskCommentCell: View {
    let comment: TaskCommentsModel.TaskCommentsResponse
    let userID: Int
    @EnvironmentObject var taskCommentsVM: TaskCommentsViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: DesignConstants.Form.Spacing.minimalSpacing) {
            // Sender name and time
            HStack {
                Text(self.taskCommentsVM.getCommentAuthorName(authorID: comment.userID!, userID: userID))
                    .font(.headline)
                
                Spacer()
                
                Text(DesignConstants.DateFormat.taskTime.string(from: Date(timeIntervalSince1970: comment.creationDate ?? 0)))
                    .font(.footnote)
                    .foregroundColor(DesignConstants.Colors.subtitleText)
            }
            .padding(.vertical, DesignConstants.Padding.textInListCell)
            
            // Comment
            Text(comment.comment ?? "")
                .font(.subheadline)
                .padding(.bottom, DesignConstants.Padding.textInListCell)
        }
        .contextMenu {
            // If comment is by other person, show report violation button
            if comment.userID != self.userID {
                Button(action: {
                    self.taskCommentsVM.taskCommentIDToReport = self.comment.id
                    self.taskCommentsVM.showReportViolationAlert.toggle()
                }) {
                    HStack {
                        Text(LocalizableStringConstants.reportComment)
                        Image(systemName: ImageNameConstants.SFSymbolConstants.reportComment)
                    }
                }
            }
        }
    }
}
