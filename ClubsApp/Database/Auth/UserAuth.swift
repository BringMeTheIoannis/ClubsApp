//
//  UserAuth.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 8.02.23.
//

import Foundation
import FirebaseAuth

class UserAuth {
    
    func registerUser(email: String, password: String, success: ((AuthDataResult) -> Void)?, failure: ((Error?) -> Void)?) {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard let result = result, error == nil else {
                failure?(error)
                return
            }
            success?(result)
        }
    }
}
