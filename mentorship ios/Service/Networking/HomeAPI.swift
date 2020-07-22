//
//  HomeAPI.swift
//  Created on 22/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class HomeAPI: HomeService {
    private var cancellable: AnyCancellable?
    var homeResponse = HomeModel.HomeResponseData(asMentor: nil, asMentee: nil, tasksToDo: nil, tasksDone: nil)
    
    func fetchDashboard(completion: @escaping (HomeModel.HomeResponseData) -> Void) {
        //get auth token
        guard let token = try? KeychainManager.getToken() else {
            return
        }
        
        //api call
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.Users.home, token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(self.homeResponse) }
            .sink { home in
                completion(home)
        }
    }
}
