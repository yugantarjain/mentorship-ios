//
//  ContentView.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 30/05/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI
import Combine

extension UserDefaults {
    @objc dynamic var isLoggedIn: Bool {
        return bool(forKey: "isLoggedIn")
    }
}

struct ContentView: View {
    @State private var selection = 0
    @State private var isLogged = false
    
    var body: some View {
        let _: AnyCancellable? = UserDefaults.standard
            .publisher(for: \.isLoggedIn)
            .sink {
                print($0)
        }
        
        if true {
            return AnyView(Login())
        } else {
            return AnyView(TabView(selection: $selection) {
                Home()
                    .tabItem {
                        VStack {
                            Image("first")
                            Text("First")
                        }
                }.tag(0)
                
                Members()
                    .tabItem {
                        VStack {
                            Image("second")
                            Text("Second")
                        }
                }.tag(1)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
