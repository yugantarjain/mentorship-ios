//
//  TaskComments.swift
//  Created on 15/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct TaskComments: View {
    var task: TaskStructure
    
    var body: some View {
        Text(task.description ?? "")
        .navigationBarTitle("Task Comments")
    }
}

struct TaskComments_Previews: PreviewProvider {
    static var previews: some View {
        TaskComments(task: TaskStructure(id: 0, description: "preview task", isDone: false, createdAt: 0, completedAt: 0))
    }
}
