//
//  SignInViewModel.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 4/30/23.
//

import Foundation
import FirebaseAuth

class SignInViewModel {
    
    func checkSignedIn() -> Bool {
        return NetworkManager.shared.checkSignIn()
    }
    
    func signIn(email: String, password: String, completeionHandler: @escaping(((AuthDataResult?, Error?) -> Void))) {
        NetworkManager.shared.SignIn(email: email , password: password) { result, error in
            completeionHandler(result ,error)
        }
    }
}
