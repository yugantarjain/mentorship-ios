//
//  GoogleSignInButton.swift
//  Created on 09/08/20
//  Created for AnitaB.org Mentorship-iOS 
//

import SwiftUI
import GoogleSignIn
import AuthenticationServices

struct SocialLogin: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
    }
    
    // show google sign in flow
    func attemptLoginGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
}

// Used in login view model
class AppleLoginCoordinator: NSObject, ASAuthorizationControllerDelegate {
    let loginService: LoginService = LoginAPI()
    var loginViewModel: LoginViewModel
    
    init(loginVM: LoginViewModel) {
        self.loginViewModel = loginVM
    }
    
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func signInWithAppleNetworkRequest(idToken: String, name: String, email: String) {
        loginViewModel.inActivity = true
        loginService.socialSignInCallback(
            socialSignInData: .init(idToken: idToken, name: name, email: email),
            socialSignInType: .apple) { response in
                print(response)
                self.loginViewModel.update(using: response)
                self.loginViewModel.inActivity = false
        }
    }
    
    // Delegate methods
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Get user details
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email ?? ""
            let name = (fullName?.givenName ?? "") + (" ") + (fullName?.familyName ?? "")
            
            // Make network request to backend
            signInWithAppleNetworkRequest(idToken: userIdentifier, name: name, email: email)
            
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
