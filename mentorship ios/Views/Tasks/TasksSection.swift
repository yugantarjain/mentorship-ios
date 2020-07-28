//
//  TasksToDoSection.swift
//  Created on 01/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct TasksSection: View {
    let tasks: [TaskStructure]?
    //used to enable mark as complete for to do tasks only.
    var isToDoSection: Bool = false
    var reqID: Int = -1
    var reqName: String = ""
    var markAsCompleteAction: (TaskStructure) -> Void = { _ in }
    
    var iconName: String {
        if isToDoSection {
            return ImageNameConstants.SFSymbolConstants.taskToDo
        } else {
            return ImageNameConstants.SFSymbolConstants.taskDone
        }
    }
    
    var body: some View {
        Section(header: Text(LocalizableStringConstants.tasksToDo).font(.headline)) {
            ForEach(tasks ?? []) { task in
                //Tapping leads to task comments page
                NavigationLink(destination: TaskComments(taskID: task.id ?? -1, reqID: self.reqID, reqName: self.reqName)) {
                    //Main HStack, shows icon and task
                    HStack {
                        Image(systemName: self.iconName)
                            .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
                            .padding(.trailing, DesignConstants.Padding.insetListCellFrameExpansion)
                        
                        Text(task.description ?? "-")
                            .font(.subheadline)
                    }
                    .padding(DesignConstants.Padding.insetListCellFrameExpansion)
                    //context menu used to show and enable actions (eg. mark as complete)
                    .contextMenu {
                        if self.isToDoSection {
                            Button("Mark as Complete") { self.markAsCompleteAction(task) }
                        }
                    }
                }
            }
        }
    }
}
