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
// To fetch dashboard data and populate home screen
protocol HomeService {
    func fetchDashboard(completion: @escaping (HomeModel.HomeResponseData) -> Void)
}

//MARK: - Profile Service
// To fetch user profile
protocol ProfileService {
    func getProfile(completion: @escaping (ProfileModel.ProfileData) -> Void)
}