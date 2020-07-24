//
//  HomeAPI.swift
//  Created on 22/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

import Foundation
import Combine

class HomeAPI: HomeService {
    private var cancellable: AnyCancellable?
    
    func fetchDashboard(completion: @escaping (HomeModel.HomeResponseData) -> Void) {
        //get auth token
        guard let token = try? KeychainManager.getToken() else {
            return
        }
        
        //api call
        cancellable = NetworkManager.callAPI(urlString: URLStringConstants.Users.home, token: token)
            .receive(on: RunLoop.main)
            .catch { _ in Just(HomeNetworkModel(asMentor: nil, asMentee: nil, tasksToDo: nil, tasksDone: nil)) }
            .sink { home in
                let homeResponse = HomeModel.HomeResponseData(
                    asMentor: home.asMentor,
                    asMentee: home.asMentee,
                    tasksToDo: home.tasksToDo,
                    tasksDone: home.tasksDone)
                completion(homeResponse)
        }
    }
}

// MARK: Network Model
extension HomeAPI {
    struct HomeNetworkModel: Decodable {
        let asMentor: RequestsList?
        let asMentee: RequestsList?
        
        let tasksToDo: [TaskStructure]?
        let tasksDone: [TaskStructure]?
        
        enum CodingKeys: String, CodingKey {
            case asMentor = "as_mentor"
            case asMentee = "as_mentee"
            case tasksToDo = "tasks_todo"
            case tasksDone = "tasks_done"
        }
    }
}
