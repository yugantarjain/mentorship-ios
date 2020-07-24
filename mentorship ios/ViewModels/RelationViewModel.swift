//
//  RelationViewModel.swift
//  Created on 02/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI
import Combine

class RelationViewModel: ObservableObject {
    
    // MARK: - Variables
    @Published var currentRelation = RelationModel().currentRelation
    @Published var responseData = RelationModel.ResponseData(message: "", success: false)
    var tasks = RelationModel().tasks
    var firstTimeLoad = true
    @Published var newTask = RelationModel.AddTaskData(description: "")
    @Published var toDoTasks = RelationModel().tasks
    @Published var doneTasks = RelationModel().tasks
    @Published var inActivity = false
    @Published var addTask = false
    @Published var personName = ""
    @Published var personType = LocalizedStringKey("")
    @Published var showAlert = false
    @Published var showErrorAlert = false
    @Published var alertTitle = LocalizableStringConstants.failure
    @Published var alertMessage = LocalizedStringKey("")
    static var taskTapped = RelationModel().task
    private var cancellable: AnyCancellable?
    
    // MARK: - Functions
    func handleFetchedTasks(tasks: [TaskStructure], success: Bool) {
        if success {
            doneTasks.removeAll()
            toDoTasks.removeAll()
            for task in tasks {
                task.mapTo(viewModel: self)
            }
        } else {
            showErrorAlert = true
            alertMessage = LocalizableStringConstants.operationFail
        }
    }
    
    //func to get name of other person in current relation.
    func getPersonNameAndType(data: RequestStructure) -> String {
        //get user profile
        let userProfile = ProfileViewModel().getProfile()
        //match users name with mentee name.
        //if different, return mentee's name. Else, return mentor's name
        //Logic: Person with different name is in relation with us.
        if data.mentee?.name != userProfile.name {
            self.personType = LocalizableStringConstants.mentee
            return data.mentee?.name ?? ""
        } else {
            self.personType = LocalizableStringConstants.mentor
            return data.mentor?.name ?? ""
        }
    }
}
