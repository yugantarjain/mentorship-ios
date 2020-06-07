//
//  Members.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 07/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI

struct Members: View {
    @ObservedObject var membersModel = MembersModel()
    var body: some View {
        NavigationView {
            List {
                if self.membersModel.inActivity {
                    ActivityIndicator(isAnimating: self.$membersModel.inActivity, style: .medium)
                }
                ForEach(membersModel.membersResponseData) { member in
                    VStack(alignment: .leading) {
                        
                        Text(member.name ?? "")
                            .font(.headline)
                        
                        Text(self.membersModel.availabilityString(canBeMentee: member.need_mentoring ?? false, canBeMentor: member.available_to_mentor ?? false))
                            .font(.subheadline)
                        
                        Text(self.membersModel.skillsString(skills: member.skills ?? ""))
                            .font(.subheadline)
                    }
                }
            }
            .navigationBarTitle("Members")
            .onAppear(perform: membersModel.fetchMembers)
        }
    }
}

struct Members_Previews: PreviewProvider {
    static var previews: some View {
        Members()
    }
}
