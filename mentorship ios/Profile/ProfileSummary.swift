//
//  Profile.swift
//  Created on 18/06/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct ProfileSummary: View {
    @ObservedObject var profileModel = ProfileModel()
    var profileData: ProfileModel.ProfileData {
        return profileModel.getProfile()
    }
    let hideEmptyFields = false
    @Environment(\.presentationMode) var presentation
    @State private var showProfileEditor = false
    
    var body: some View {
        NavigationView {
            Form {
                //grouping done because maximum 10 views can be defined inside a closure.
                Group {
                    MemberDetailCell(type: .username, value: profileData.username, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(type: .email, value: profileData.email, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(type: .needsMentor, value: profileData.needMentoring ?? false ? "Yes" : "No", hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(type: .isMentor, value: profileData.availableToMentor ?? false ? "Yes" : "No", hideEmptyFields: hideEmptyFields)
                }
                Group {
                    MemberDetailCell(type: .bio, value: profileData.bio, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(type: .location, value: profileData.location, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(type: .occupation, value: profileData.occupation, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(type: .organization, value: profileData.organization, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(type: .slackUsername, value: profileData.slackUsername, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(type: .skills, value: profileData.skills, hideEmptyFields: hideEmptyFields)
                    MemberDetailCell(type: .interests, value: profileData.interests, hideEmptyFields: hideEmptyFields)
                }
            }
            .navigationBarTitle(profileData.name ?? "Profile")
            .navigationBarItems(leading:
                Button(action: { self.presentation.wrappedValue.dismiss() }) {
                    Image(systemName: ImageNameConstants.SFSymbolConstants.xCircle)
                        .accentColor(.secondary)
                }, trailing: Button("Edit", action: {
                    self.showProfileEditor.toggle()
                }))
            .sheet(isPresented: $showProfileEditor) {
                ProfileEditor()
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary()
    }
}
