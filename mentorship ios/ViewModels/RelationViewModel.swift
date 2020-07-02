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
    @Published var tasks = RelationModel().tasks
    @Published var inActivity = false
    @Published var personName = ""
    private var cancellable: AnyCancellable?
    
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
            .sink { [weak self] in
                print($0)
                self?.currentRelation = $0
                self?.personName = self?.getPersonName(data: $0) ?? ""
                self?.inActivity = false
                self?.cancellable = NetworkManager.callAPI(urlString: URLStringConstants.MentorshipRelation.getCurrentTasks(id: $0.id ?? 0), token: token)
                    .catch { _ in Just(self?.tasks) }
                    .sink {
                        print($0)
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
}
