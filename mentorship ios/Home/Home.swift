//
//  Home.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 05/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI

struct Home: View {
    @ObservedObject var homeModel = HomeModel()
    var body: some View {
        Text("Home")
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
