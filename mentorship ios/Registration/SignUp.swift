//
//  SignUpView.swift
//  mentorship ios
//
//  Created by Yugantar Jain on 01/06/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import SwiftUI

struct SignUp: View {
    @ObservedObject var signUpModel = SignUpModel()
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: DesignConstants.Spacing.bigSpacing) {
                    //input fields for name, email, password, etc.
                    VStack(spacing: DesignConstants.Spacing.smallSpacing) {
                        TextField("Name", text: $signUpModel.signUpData.name)
                            .textFieldStyle(RoundFilledTextFieldStyle())
                        TextField("Username", text: $signUpModel.signUpData.username)
                            .textFieldStyle(RoundFilledTextFieldStyle())
                        TextField("Email", text: $signUpModel.signUpData.email)
                            .textFieldStyle(RoundFilledTextFieldStyle())
                        SecureField("Password", text: $signUpModel.signUpData.password)
                            .textFieldStyle(RoundFilledTextFieldStyle())
                        SecureField("Confirm Password", text: $signUpModel.confirmPassword)
                            .textFieldStyle(RoundFilledTextFieldStyle())
                    }
                    
                    //select availability as mentor, mentee, or both
                    VStack {
                        Text("Available to be a:").font(.headline)
                        
                        Picker(selection: $signUpModel.availabilityPickerSelection, label: Text("")) {
                            Text("Mentor").tag(1)
                            Text("Mentee").tag(2)
                            Text("Both").tag(3)
                        }
                        .labelsHidden()
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    //sign up button
                    Button("Sign Up") {
                        self.signUpModel.signUp()
                    }
                    .buttonStyle(BigBoldButtonStyle(disabled: signUpModel.signupDisabled))
                    .disabled(signUpModel.signupDisabled)
                    
                    //activity indicator or message for user if present
                    if signUpModel.inActivity {
                        ActivityIndicator(isAnimating: $signUpModel.inActivity, style: .medium)
                    } else if !(self.signUpModel.signUpResponseData.message?.isEmpty ?? true) {
                        Text(self.signUpModel.signUpResponseData.message ?? "")
                            .font(DesignConstants.Fonts.userError)
                            .foregroundColor(DesignConstants.Colors.userError)
                    }
                    
                    //consent view, to accept terms and conditions
                    HStack {
                        Toggle(isOn: $signUpModel.signUpData.terms_and_conditions_checked) {
                            Text(LocalizableStringConstants.tncString)
                                .font(.caption)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    
                    //spacer to push content to top and have bottom space for scroll view
                    Spacer()
                }
                .padding(.top, DesignConstants.Padding.topPadding)
                .padding(.bottom, DesignConstants.Padding.bottomPadding)
                .padding(.leading, DesignConstants.Padding.leadingPadding)
                .padding(.trailing, DesignConstants.Padding.trailingPadding)
            }
            .navigationBarTitle("Sign Up")
            .navigationBarItems(leading:
                Button.init(action: {
                    self.isPresented = false
                }, label: {
                    Image(systemName: "x.circle.fill")
                        .font(.headline)
                        .accentColor(.secondary)
                })
            )
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUp(isPresented: .constant(true))
                .environment(\.locale, .init(identifier: "en"))
        }
    }
}
