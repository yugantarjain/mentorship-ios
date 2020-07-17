//
//  RequestActionViewModel.swift
//  Created on 18/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation

class RequestActionViewModel: ObservableObject {
    @Published var success = false
    @Published var actionType: RelationRequestActionAPI.ActionType!
    
    let requestActionAPI = RelationRequestActionAPI()
    
    func performRequestAction(reqID: Int) {
        requestActionAPI.actOnPendingRequest(action: actionType, reqID: reqID) {_ in 
            if NetworkManager.responseCode == 200 {
                self.success = true
            }
        }
    }
}
