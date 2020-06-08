//
//  MemberDetail.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 08/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI

struct MemberDetail: View {
    var member: MembersModel.MembersResponseData
    
    var body: some View {
        Form {
            Group {
                MemberDetailCell(title: "Username", value: member.username)
                MemberDetailCell(title: "Slack Username", value: member.slackUsername)
                MemberDetailCell(title: "Is a Mentor", value: member.availableToMentor ?? false ? "Yes" : "No")
                MemberDetailCell(title: "Needs a Mentor", value: member.needMentoring ?? false ? "Yes" : "No")
                MemberDetailCell(title: "Interests", value: member.interests)
                MemberDetailCell(title: "Bio", value: member.bio)
                MemberDetailCell(title: "Location", value: member.location)
                MemberDetailCell(title: "Occupation", value: member.occupation)
                MemberDetailCell(title: "Organization", value: member.organization)
                MemberDetailCell(title: "Skills", value: member.skills)
            }
            
//            Button(action: {}) {
//                Text("Send Request")
//                    .font(.headline)
//                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
//                    .padding(DesignConstants.Padding.listCellFrameExpansion)
//                    .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
//            }
        }
        .navigationBarTitle(member.name ?? "Member Detail")
        .navigationBarItems(trailing:
            Button(action: {}) {
                Text("Send Request")
                    .font(.headline)
                    .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
            }
        )
    }
}

struct MemberDetail_Previews: PreviewProvider {
    static var previews: some View {
        MemberDetail(member: MembersModel.MembersResponseData.init(id: 1, username: "username", name: "yugantar", bio: "student", location: "earth", occupation: "student", organization: "", interests: "astronomy", skills: "ios, swift, c++", slackUsername: "", needMentoring: true, availableToMentor: true, isAvailable: true))
    }
}