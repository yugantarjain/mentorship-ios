//
//  MemberDetail.swift
//  Created on 08/06/20.
//  Created for AnitaB.org Mentorship-iOS
//

import SwiftUI

struct MemberDetail: View {
    var member: MembersModel.MembersResponseData
    @State private var showSendRequestSheet = false
    let hideEmptyFields = true

    var body: some View {
        Form {
            Group {
                MemberDetailCell(type: .username, value: member.username, hideEmptyFields: hideEmptyFields)
                MemberDetailCell(type: .slackUsername, value: member.slackUsername, hideEmptyFields: hideEmptyFields)
                MemberDetailCell(type: .isMentor, value: member.availableToMentor ?? false ? "Yes" : "No", hideEmptyFields: hideEmptyFields)
                MemberDetailCell(type: .needsMentor, value: member.needMentoring ?? false ? "Yes" : "No", hideEmptyFields: hideEmptyFields)
                MemberDetailCell(type: .interests, value: member.interests, hideEmptyFields: hideEmptyFields)
                MemberDetailCell(type: .bio, value: member.bio, hideEmptyFields: hideEmptyFields)
                MemberDetailCell(type: .location, value: member.location, hideEmptyFields: hideEmptyFields)
                MemberDetailCell(type: .occupation, value: member.occupation, hideEmptyFields: hideEmptyFields)
                MemberDetailCell(type: .organization, value: member.organization, hideEmptyFields: hideEmptyFields)
                MemberDetailCell(type: .skills, value: member.skills, hideEmptyFields: hideEmptyFields)
            }
        }
        .navigationBarTitle(member.name ?? "Member Detail")
        .navigationBarItems(trailing:
            Button(action: { self.showSendRequestSheet.toggle() }) {
                Text("Send Request")
                    .font(.headline)
            }
        )
            .sheet(isPresented: $showSendRequestSheet) {
                SendRequest(memberID: self.member.id, memberName: self.member.name ?? "-")
        }
    }
}

struct MemberDetail_Previews: PreviewProvider {
    static var previews: some View {
        MemberDetail(
            member: MembersModel.MembersResponseData.init(
                id: 1,
                username: "username",
                name: "yugantar",
                bio: "student",
                location: "earth",
                occupation: "student",
                organization: "",
                interests: "astronomy",
                skills: "ios, swift, c++",
                slackUsername: "",
                needMentoring: true,
                availableToMentor: true,
                isAvailable: true
            )
        )
    }
}
