//
//  RelationViewModel.swift
//  Created on 02/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class RelationViewModel: ObservableObject {
    
    // MARK: - Variables
    @Published var currentRelation = RelationModel().currentRelation
    @Published var responseData = RelationModel.ResponseData(message: "")
    var tasks = RelationModel().tasks
    @Published var newTask = RelationModel.AddTaskData(description: "")
    @Published var toDoTasks = RelationModel().tasks
    @Published var doneTasks = RelationModel().tasks
    @Published var inActivity = false
    @Published var addTask = false
    @Published var personName = ""
    static var taskTapped = RelationModel().task
    private var cancellable: AnyCancellable?
    private var tasksCancellable: AnyCancellable?
    
    // MARK: - Functions
    init() {
        fetchCurrentRelation()
    }
    
    func fetchCurrentRelation() {
        //get auth token
        guard let token = try? KeychainManager.readKeychain() else {
            return
        }
        
        //set inActivity
        inActivity = true
        
        //api call
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.MentorshipRelation.currentRelation, token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.currentRelation) }
            .sink { [weak self] current in
                //use current relation data
                self?.currentRelation = current
                self?.personName = self?.getPersonName(data: current) ?? ""
                self?.inActivity = false
                //chain api call. get current tasks using id from current relation
                self?.fetchTasks(id: current.id ?? 0, token: token)
        }
    }
    
    func fetchTasks(id: Int, token: String) {
        self.tasksCancellable = NetworkManager.callAPI(urlString: URLStringConstants.MentorshipRelation.getCurrentTasks(id: id), token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.tasks) }
            .sink { [weak self] tasks in
                if NetworkManager.responseCode == 200 {
                    self?.doneTasks.removeAll()
                    self?.toDoTasks.removeAll()
                    //assign done tasks and tasks to do
                    for task in tasks {
                        if task.isDone ?? false {
                            self?.doneTasks.append(task)
                        } else {
                            self?.toDoTasks.append(task)
                        }
                    }
                }
        }
    }
    
    //func to get name of other person in current relation.
    func getPersonName(data: HomeModel.HomeResponseData.RequestStructure) -> String {
        //get user profile
        let userProfile = ProfileViewModel().getProfile()
        //match users name with mentee name.
        //if different, return mentee's name. Else, return mentor's name
        //Logic: Person with different name is in relation with us.
        if data.mentee?.name != userProfile.name {
            return data.mentee?.name ?? ""
        } else {
            return data.mentor?.name ?? ""
        }
    }
    
    //mark task as complete api call + data change
    func markAsComplete() {
        //get auth token
        guard let token = try? KeychainManager.readKeychain() else {
            return
        }
        
        //get tapped task
        let taskTapped = RelationViewModel.taskTapped
        
        //api call
        cancellable = NetworkManager.callAPI(
            urlString: URLStringConstants.MentorshipRelation.markAsComplete(reqID: currentRelation.id ?? 0, taskID: taskTapped.id ?? 0),
            httpMethod: "PUT",
            token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.responseData) }
            .sink { [weak self] in
                self?.responseData = $0
                if NetworkManager.responseCode == 200 {
                    if let i = self?.toDoTasks.firstIndex(of: taskTapped) {
                        self?.toDoTasks.remove(at: i)
                        self?.doneTasks.append(taskTapped)
                    }
                }
        }
    }
    
    //create newtask api call
    func addNewTask() {
        //get auth token
        guard let token = try? KeychainManager.readKeychain() else {
            return
        }
        
        //prepare upload data
        guard let uploadData = try? JSONEncoder().encode(newTask) else {
            return
        }
        
        //api call
        cancellable = NetworkManager.callAPI(
            urlString: URLStringConstants.MentorshipRelation.addNewTask(reqID: currentRelation.id ?? 0),
            httpMethod: "POST",
            uploadData: uploadData,
            token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.responseData) }
            .sink { [weak self] in
                self?.responseData = $0
                self?.fetchTasks(id: self?.currentRelation.id ?? 0, token: token)
                self?.addTask.toggle()
        }
    }
}
