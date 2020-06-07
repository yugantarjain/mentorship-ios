//
//  AuthModel.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 08/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import Foundation
import Combine

final class AuthModel: ObservableObject {
//    @Published var isLogged: Bool = false
//    var didChange: AnyPublisher<Bool, Never>
//
//    init() {
//        let defaults = UserDefaults.standard
//        didChange = defaults.publisher(for: \.isLoggedIn)
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//    }
    
    public var didChange = UserDefaults.standard.publisher(for: \.isLoggedIn)
        .receive(on: RunLoop.main)
    
    var sub = AuthModel().didChange.sink() {
        print($0)
    }
}
