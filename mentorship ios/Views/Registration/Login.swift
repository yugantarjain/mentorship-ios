//
//  LoginView.swift
//  Created on 01/06/20.
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct Login: View {
    var loginService: LoginService = LoginAPI()
    @State private var showSignUpPage: Bool = false
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    // Use service to login
    func login() {
        self.loginService.login(loginData: self.loginViewModel.loginData) { response in
            // update login view model
            self.loginViewModel.update(using: response)
            self.loginViewModel.inActivity = false
        }
    }
    
    var body: some View {
        VStack(spacing: DesignConstants.Form.Spacing.bigSpacing) {
            //top image of mentorship logo
            Image(ImageNameConstants.mentorshipLogoImageName)
                .resizable()
                .scaledToFit()
            
            //username and password text fields
            VStack(spacing: DesignConstants.Form.Spacing.smallSpacing) {
                TextField("Username/Email", text: $loginViewModel.loginData.username)
                    .textFieldStyle(RoundFilledTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $loginViewModel.loginData.password)
                    .textFieldStyle(RoundFilledTextFieldStyle())
            }
            
            //login button
            Button("Login") {
                // set inActivity to true (shows activity indicator)
                self.loginViewModel.inActivity = true
                self.login()
            }
            .buttonStyle(BigBoldButtonStyle(disabled: loginViewModel.loginDisabled))
            .disabled(loginViewModel.loginDisabled)
            
            //text and sign up button
            VStack(spacing: DesignConstants.Form.Spacing.minimalSpacing) {
                Text(LocalizableStringConstants.noAccountText)
                
                Button.init(action: { self.showSignUpPage.toggle() }) {
                    Text("Signup")
                        .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
                }
                .sheet(isPresented: $showSignUpPage) {
                    SignUp(isPresented: self.$showSignUpPage)
                }
            }
            
            //activity indicator or show user message text
            if self.loginViewModel.inActivity {
                ActivityIndicator(isAnimating: $loginViewModel.inActivity)
            } else if !(self.loginViewModel.loginResponseData.message?.isEmpty ?? true) {
                Text(self.loginViewModel.loginResponseData.message ?? "")
                    .modifier(ErrorText())
            }
            
            // Divider for social sign in options
            ZStack {
                Divider()
                Text("OR")
            }
            
            // Social sign in buttons
            VStack {
                AppleSignInButton()
                    .onTapGesture {
                        self.loginViewModel.attemptAppleLogin()
                }
                
                GoogleSignInButton()
                    .onTapGesture {
                        SocialSignIn().attemptSignInGoogle()
                }
            }
            .frame(height: DesignConstants.Height.textViewHeight)
        }
        .modifier(AllPadding())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
