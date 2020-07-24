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
    @Published var responseData = RelationModel.ResponseData(message: "")
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
    
    //mark task as complete api call + data change
    func markAsComplete() {
        //get auth token
        guard let token = try? KeychainManager.getToken() else {
            return
        }
        
        //set parameters
        let taskTapped = RelationViewModel.taskTapped
        guard let taskID = taskTapped.id else { return }
        guard let relationID = currentRelation.id else { return }
        
        //api call
        cancellable = NetworkManager.callAPI(
            urlString: URLStringConstants.MentorshipRelation.markAsComplete(reqID: relationID, taskID: taskID),
            httpMethod: "PUT",
            token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.responseData) }
            .sink { [weak self] in
                self?.responseData = $0
                if NetworkManager.responseCode == 200 {
                    if let index = self?.toDoTasks.firstIndex(of: taskTapped) {
                        self?.toDoTasks.remove(at: index)
                        self?.doneTasks.append(taskTapped)
                    }
                } else {
                    self?.showErrorAlert = true
                    self?.alertMessage = LocalizableStringConstants.operationFail
                }
        }
    }
    
    //create newtask api call
    func addNewTask() {
        //get auth token
        guard let token = try? KeychainManager.getToken() else {
            return
        }
        
        //prepare upload data
        guard let uploadData = try? JSONEncoder().encode(newTask) else {
            return
        }
        
        //set parameters
        guard let relationID = self.currentRelation.id else { return }
        
        //api call
        cancellable = NetworkManager.callAPI(
            urlString: URLStringConstants.MentorshipRelation.addNewTask(reqID: relationID),
            httpMethod: "POST",
            uploadData: uploadData,
            token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.responseData) }
            .sink { [weak self] in
                //if success, dismiss sheet and refresh tasks
                if NetworkManager.responseCode == 201 {
                    self?.addTask.toggle()
//                    self?.fetchTasks(id: relationID, token: token)
                }
                //else the error message (responseData) is shown on add task screen
                else {
                    self?.responseData = $0
                }
        }
    }
}
