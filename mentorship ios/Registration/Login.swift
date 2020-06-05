//
//  LoginView.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 01/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI

struct Login: View {
    @State private var showSignUpPage: Bool = false
    @ObservedObject var loginModel = LoginModel()
            
    var body: some View {
        VStack(spacing: DesignConstants.Spacing.bigSpacing) {
            //top image of mentorship logo
            Image(ImageNameConstants.mentorshipLogoImageName)
                .resizable()
                .scaledToFit()
            
            //username and password text fields
            VStack(spacing: DesignConstants.Spacing.smallSpacing) {
                TextField("Username/Email", text: $loginModel.loginUploadData.username)
                    .textFieldStyle(RoundFilledTextFieldStyle())
                
                SecureField("Password", text: $loginModel.loginUploadData.password)
                    .textFieldStyle(RoundFilledTextFieldStyle())
            }
            
            //login button
            Button("Login") {
                self.loginModel.login()
            }
            .buttonStyle(BigBoldButtonStyle(disabled: loginModel.loginDisabled))
            .disabled(loginModel.loginDisabled)
            
            //message text
            if loginModel.loginResponseData.message.isEmpty == false {
                Text(loginModel.loginResponseData.message!)
            }
            
            //text and sign up button
            VStack(spacing: DesignConstants.Spacing.minimalSpacing) {
                Text("Don't have an account?")
                
                Button.init(action: { self.showSignUpPage.toggle() }) {
                    Text("Signup")
                        .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
                }.sheet(isPresented: $showSignUpPage) {
                    SignUpView.init()
                }
            }
                        
            //spacer to push content to top
            Spacer()
        }
        .padding(.top, DesignConstants.Padding.topPadding)
        .padding(.bottom, DesignConstants.Padding.bottomPadding)
        .padding(.leading, DesignConstants.Padding.leadingPadding)
        .padding(.trailing, DesignConstants.Padding.trailingPadding)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
