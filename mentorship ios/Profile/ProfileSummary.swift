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
                //Show common details : name, username, occupation, etc.
                ProfileCommonDetailsSection(memberData: profileData, hideEmptyFields: false)
                //Show email
                Text(profileData.email ?? "")
                    .font(.subheadline)
                    .listRowBackground(DesignConstants.Colors.formBackgroundColor)
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
