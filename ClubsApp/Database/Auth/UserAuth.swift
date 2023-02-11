//
//  UserAuth.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 8.02.23.
//

import Foundation
import FirebaseAuth

class UserAuth {
    let auth = FirebaseAuth.Auth.auth()
    
    func registerUser(email: String, password: String, success: ((AuthDataResult) -> Void)?, failure: ((Error?) -> Void)?) {
        auth.createUser(withEmail: email, password: password) { result, error in
            guard let result = result, error == nil else {
                failure?(error)
                return
            }
            success?(result)
        }
    }
    
    func signIn(email: String, password: String, success: ((AuthDataResult) -> Void)?, failure: ((Error?) -> Void)?) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result, error == nil else {
                failure?(error)
                return
            }
            success?(result)
        }
    }
    
    func resetPassword(email: String, success: ((String) -> Void)? , failure: ((Error) -> Void)?) {
        auth.sendPasswordReset(withEmail: email) { error in
            guard let error = error else {
                success?("Успешно")
                return
            }
            failure?(error)
        }
    }
}
