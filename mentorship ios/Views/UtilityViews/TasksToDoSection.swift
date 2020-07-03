//
//  TasksToDoSection.swift
//  Created on 01/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct TasksToDoSection<T: TaskStructureProperties>: View {
    var tasksToDo: [T]
    var onTapAction: (HomeModel.HomeResponseData.TaskStructure) -> Void
    
    //intialiser for view
    init(tasksToDo: [T]?, onTapAction: @escaping (HomeModel.HomeResponseData.TaskStructure) -> Void = { _ in }) {
        self.tasksToDo = tasksToDo ?? []
        self.onTapAction = onTapAction
    }

    var body: some View {
        Section(header: Text(LocalizableStringConstants.tasksToDo).font(.headline)) {
            ForEach(tasksToDo) { task in
                HStack {
                    Image(systemName: ImageNameConstants.SFSymbolConstants.taskToDo)
                        .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
                        .padding(.trailing, DesignConstants.Padding.insetListCellFrameExpansion)

                    Text(task.description ?? "-")
                        .font(.subheadline)
                }
                .onTapGesture {
                    // swiftlint:disable:next all
                    //run tap action closure
                    self.onTapAction(task as! HomeModel.HomeResponseData.TaskStructure)
                }
            }
        }
    }
}
