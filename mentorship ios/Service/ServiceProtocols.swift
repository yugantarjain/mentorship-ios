//
//  RequestActionService.swift
//  Created on 22/07/20
//  Created for AnitaB.org Mentorship-iOS 
//

// MARK: - Login Service.
// To login into main app.
protocol LoginService {
    func login(
        loginData: LoginModel.LoginUploadData,
        completion: @escaping (LoginModel.LoginResponseData) -> Void
    )
}

// MARK: - SignUp Service
// To sign up as a new user.
protocol SignUpService {
    func signUp(
        availabilityPickerSelection: Int,
        signUpData: SignUpModel.SignUpUploadData,
        confirmPassword: String,
        completion: @escaping (SignUpModel.SignUpResponseData) -> Void
    )
}

// MARK: - Home Service
// To fetch dashboard data and populate home screen
protocol HomeService {
    func fetchDashboard(completion: @escaping (HomeModel.HomeResponseData) -> Void)
}

// MARK: - Request Action Service
// To accept, reject, delete, or cancel a request
protocol RequestActionService {
    func actOnPendingRequest(
        action: ActionType,
        reqID: Int,
        completion: @escaping (ResponseMessage, Bool) -> Void
    )
}

// MARK: - Profile Service
// To fetch and update user profile
protocol ProfileService {
    func getProfile(completion: @escaping (ProfileModel.ProfileData) -> Void)
    
    func updateProfile(
        updateProfileData: ProfileModel.ProfileData,
        completion: @escaping (ProfileModel.UpdateProfileResponseData, Bool) -> Void
    )
}


