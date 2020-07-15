//
//  TasksToDoSection.swift
//  Created on 01/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct TasksSection: View {
    var tasks: [TaskStructure]?
    var markAsCompleteAction: (TaskStructure) -> Void
    //used to enable mark as complete for to do tasks only.
    var isToDoSection: Bool
    
    var iconName: String {
        if isToDoSection {
            return ImageNameConstants.SFSymbolConstants.taskToDo
        } else {
            return ImageNameConstants.SFSymbolConstants.taskDone
        }
    }
    
    //intialiser for view
    init(tasks: [TaskStructure]?, markAsCompleteAction: @escaping (TaskStructure) -> Void = { _ in }, isToDoSection: Bool = false) {
        self.tasks = tasks ?? []
        self.markAsCompleteAction = markAsCompleteAction
        self.isToDoSection = isToDoSection
    }
    
    var body: some View {
        Section(header: Text(LocalizableStringConstants.tasksToDo).font(.headline)) {
            ForEach(tasks ?? []) { task in
                //Tapping leads to task comments page
                NavigationLink(destination: Text("comments")) {
                    //Main HStack shows icon and task
                    HStack {
                        Image(systemName: self.iconName)
                            .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
                            .padding(.trailing, DesignConstants.Padding.insetListCellFrameExpansion)
                        
                        Text(task.description ?? "-")
                            .font(.subheadline)
                    }
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
