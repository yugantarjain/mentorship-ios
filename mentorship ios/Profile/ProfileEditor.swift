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
                    ProfileEditField(title: "Name", value: Binding($editProfileData.name)!)
                    ProfileEditField(title: "Username", value: Binding($editProfileData.username)!)
                    Toggle(isOn: Binding($editProfileData.needMentoring)!) {
                        Text("Needs Mentoring").bold()
                    }
                    Toggle(isOn: Binding($editProfileData.availableToMentor)!) {
                        Text("Can be a Mentor").bold()
                    }
                }
                
                Section {
                    ProfileEditField(title: "Bio", value: Binding($editProfileData.bio)!)
                    ProfileEditField(title: "Location", value: Binding($editProfileData.location)!)
                    ProfileEditField(title: "Occupation", value: Binding($editProfileData.occupation)!)
                    ProfileEditField(title: "Organization", value: Binding($editProfileData.organization)!)
                    ProfileEditField(title: "Slack Username", value: Binding($editProfileData.slackUsername)!)
                    ProfileEditField(title: "Skills", value: Binding($editProfileData.skills)!)
                    ProfileEditField(title: "Interests", value: Binding($editProfileData.interests)!)
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
