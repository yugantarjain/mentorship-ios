//
//  Profile.swift
//  Created on 18/06/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct Profile: View {
    var profileData: ProfileModel.ProfileData
    let hideEmptyFields = false
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    MemberDetailCell(title: "Username", value: profileData.username, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(title: "Email", value: profileData.email, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(title: "Needs Mentoring", value: profileData.needMentoring ?? false ? "Yes" : "No", hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(title: "Can Mentor", value: profileData.availableToMentor ?? false ? "Yes" : "No", hideEmptyFields: hideEmptyFields)
                }
                Group {
                    MemberDetailCell(title: "Bio", value: profileData.bio, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(title: "Location", value: profileData.location, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(title: "Occupation", value: profileData.occupation, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(title: "Organization", value: profileData.organization, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(title: "Slack Username", value: profileData.slackUsername, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(title: "Skills", value: profileData.skills, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(title: "Interests", value: profileData.interests, hideEmptyFields: hideEmptyFields)

                }
            }
            .navigationBarTitle(profileData.name ?? "Profile")
            .navigationBarItems(leading:
                Button(action: { self.presentation.wrappedValue.dismiss() }) {
                    Image(systemName: ImageNameConstants.SFSymbolConstants.xCircle)
                        .accentColor(.secondary)
            }, trailing: EditButton())
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(profileData: ProfileModel().profileData)
    }
}
