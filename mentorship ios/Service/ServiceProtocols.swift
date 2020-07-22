//
//  RequestActionService.swift
//  Created on 22/07/20
//  Created for AnitaB.org Mentorship-iOS 
//


// MARK: - Request Action Service
// To accept, reject, delete, or cancel a request
protocol RequestActionService {
    func actOnPendingRequest(
        action: ActionType,
        reqID: Int,
        completion: @escaping (ResponseMessage, Bool) -> Void
    )
}

// MARK: - Home Service
