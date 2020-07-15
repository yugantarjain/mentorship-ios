//
//  TasksToDoSection.swift
//  Created on 01/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct TasksSection: View {
    var tasks: [TaskStructure]?
    var onTapAction: (TaskStructure) -> Void
    //used to enable mark as complete for to do tasks only.
    var isToDoSection: Bool
    
    //intialiser for view
    init(tasks: [TaskStructure]?, onTapAction: @escaping (TaskStructure) -> Void = { _ in }, isToDoSection: Bool = false) {
        self.tasks = tasks ?? []
        self.onTapAction = onTapAction
        self.isToDoSection = isToDoSection
    }
    
    var body: some View {
        Section(header: Text(LocalizableStringConstants.tasksToDo).font(.headline)) {
            ForEach(tasks ?? []) { task in
                NavigationLink(destination: Text("comments")) {
                    HStack {
                        Image(systemName: ImageNameConstants.SFSymbolConstants.taskToDo)
                            .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
                            .padding(.trailing, DesignConstants.Padding.insetListCellFrameExpansion)
                        
                        Text(task.description ?? "-")
                            .font(.subheadline)
                    }
                    .contextMenu {
                        if self.isToDoSection {
                            Button("Mark as Complete") { self.onTapAction(task) }
                        }
                    }
                }
            }
        }
    }
}
