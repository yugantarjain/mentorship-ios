//
//  ProfileEditor.swift
//  Created on 18/06/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct ProfileEditor: View {
    @Environment(\.presentationMode) var presentation
    @State var editProfileData = ProfileModel().getEditProfileData()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    ProfileEditField(type: .name, value: Binding($editProfileData.name)!)
                    ProfileEditField(type: .username, value: Binding($editProfileData.username)!)
                    Toggle(isOn: Binding($editProfileData.needMentoring)!) {
                        Text(LocalizableStringConstants.ProfileKeys.needsMentor.rawValue)//.bold()
                    }
                    Toggle(isOn: Binding($editProfileData.availableToMentor)!) {
                        Text(LocalizableStringConstants.ProfileKeys.isMentor.rawValue)//.bold()
                    }
                }
                
                Section {
                    ProfileEditField(type: .bio, value: Binding($editProfileData.bio)!)
                    ProfileEditField(type: .location, value: Binding($editProfileData.location)!)
                    ProfileEditField(type: .occupation, value: Binding($editProfileData.occupation)!)
                    ProfileEditField(type: .organization, value: Binding($editProfileData.organization)!)
                    ProfileEditField(type: .slackUsername, value: Binding($editProfileData.slackUsername)!)
                    ProfileEditField(type: .skills, value: Binding($editProfileData.skills)!)
                    ProfileEditField(type: .interests, value: Binding($editProfileData.interests)!)
                }
            }
            .navigationBarTitle("Edit Profile")
            .navigationBarItems(leading:
                Button(action: { self.presentation.wrappedValue.dismiss() }) {
                    Text("Cancel")
                }, trailing: Button(action: {}) {
                    Text("Save").bold()
                })
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor()
    }
}
