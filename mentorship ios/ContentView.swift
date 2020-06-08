//
//  ContentView.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 30/05/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var selection = 0
    @ObservedObject var authModel = AuthModel()
    
    var body: some View {
        if !(authModel.isLogged ?? true) {
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
