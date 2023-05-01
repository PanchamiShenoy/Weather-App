//
//  SignUpViewModel.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 4/30/23.
//

import Foundation
import FirebaseAuth

class SignUpViewModel {
    func signUp(email: String, password: String, completeionHandler: @escaping(((AuthDataResult?, Error?) -> Void))) {
        NetworkManager.shared.SignUp(email: email, password: password) { result, error in
            completeionHandler(result, error)
        }
    }
    
    func saveUserDetails(userDetails: [String: Any]) {
        NetworkManager.shared.writeDocument(documentName: "users",data: userDetails)
    }
}
