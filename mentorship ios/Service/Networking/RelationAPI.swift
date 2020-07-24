//
//  RelationAPI.swift
//  Created on 23/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class RelationAPI {
    private var cancellable: AnyCancellable?
    private var tasksCancellable: AnyCancellable?

    func fetchCurrentRelation(completion: @escaping (RequestStructure) -> Void) {
        //get auth token
        guard let token = try? KeychainManager.getToken() else {
            return
        }
        
        //api call
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.MentorshipRelation.currentRelation, token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(RelationModel().currentRelation) }
            .sink {
                completion($0)
        }
//            .sink { [weak self] current in
//                //use current relation data
//                self?.inActivity = false
//                self?.currentRelation = current
//                self?.personName = self?.getPersonNameAndType(data: current) ?? ""
//                //chain api call. get current tasks using id from current relation
//                //if current relation invalid, delete all tasks and return
//                guard let currentID = current.id else {
//                    self?.toDoTasks.removeAll()
//                    self?.doneTasks.removeAll()
//                    return
//                }
//                self?.fetchTasks(id: currentID, token: token)
//        }
    }
    
    func fetchTasks(id: Int, completion: @escaping ([TaskStructure], Bool) -> Void) {
        //get auth token
        guard let token = try? KeychainManager.getToken() else {
            return
        }
        
        // make api call
        tasksCancellable = NetworkManager.callAPI(urlString: URLStringConstants.MentorshipRelation.getCurrentTasks(id: id), token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(RelationModel().tasks) }
            .sink {
                var success = false
                if NetworkManager.responseCode == 200 {
                    success = true
                }
                completion($0, success)
        }
//            .sink { [weak self] tasks in
//                //if success
//                if NetworkManager.responseCode == 200 {
//                    self?.doneTasks.removeAll()
//                    self?.toDoTasks.removeAll()
//                    //assign done tasks and tasks to do
//                    for task in tasks {
//                        if task.isDone ?? false {
//                            self?.doneTasks.append(task)
//                        } else {
//                            self?.toDoTasks.append(task)
//                        }
//                    }
//                }
//                //else show fail alert
//                else {
//                    self?.showErrorAlert = true
//                    self?.alertMessage = LocalizableStringConstants.operationFail
//                }
//        }
    }
}
