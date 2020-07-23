//
//  LoginView.swift
//  Created on 01/06/20.
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI

struct Login: View {
    var loginService: LoginService = LoginAPI()
    @State private var showSignUpPage: Bool = false
    @State private var inActivity = false
    @ObservedObject var loginViewModel = LoginViewModel()

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
                self.inActivity = true
                
                self.loginService.login(loginData: self.loginViewModel.loginData) { response in
                    self.inActivity = false
                    // map response to login view model
                    response.mapTo(viewModel: self.loginViewModel)
                    // if login successful, store access token in keychain
                    if var token = response.accessToken {
                        token = "Bearer " + token
                        do {
                            try KeychainManager.setToken(username: self.loginViewModel.loginData.username, tokenString: token)
                            UserDefaults.standard.set(true, forKey: UserDefaultsConstants.isLoggedIn)
                        } catch { return }
                    }
                }
            }
            .buttonStyle(BigBoldButtonStyle(disabled: loginViewModel.loginDisabled))
            .disabled(loginViewModel.loginDisabled)

            //activity indicator or show user message text
            if inActivity {
                ActivityIndicator(isAnimating: $inActivity)
            } else {
                Text(self.loginViewModel.loginResponseData.message ?? "")
                    .modifier(ErrorText())
            }

            //text and sign up button
            VStack(spacing: DesignConstants.Form.Spacing.minimalSpacing) {
                Text(LocalizableStringConstants.noAccountText)

                Button.init(action: { self.showSignUpPage.toggle() }) {
                    Text("Signup")
                        .foregroundColor(DesignConstants.Colors.defaultIndigoColor)
                }.sheet(isPresented: $showSignUpPage) {
                    SignUp(isPresented: self.$showSignUpPage)
                }
            }

            //spacer to push content to top
            Spacer()
        }
        .modifier(AllPadding())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
