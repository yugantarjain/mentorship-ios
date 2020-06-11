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
    @Published var isLogged: Bool?
    private var cancellable: AnyCancellable?

    init() {
        URLCache.shared = URLCache(memoryCapacity: 50*1024*1024, diskCapacity: 200*1024*1024, diskPath: nil)

        cancellable = UserDefaults.standard
            .publisher(for: \.isLoggedIn)
            .sink {
                self.isLogged = $0
                print($0)
        }
    }
}
