//
//  DatabaseManager.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 10.02.23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class DatabaseManager {
    let database = Firestore.firestore()
    let currentUser = Auth.auth().currentUser?.uid
    
    func checkIsUserNameExist(username: String, success: ((Int) -> Void)?, failure: ((Error?) -> Void)?) {
        let querySetup = database.collection("users").whereField("username", isEqualTo: username)
        querySetup.getDocuments { querySnapshot, error in
            guard let querySnapshot, error == nil else {
                failure?(error)
                return
            }
            success?(querySnapshot.count)
        }
    }
    
    func addUserToUsersCollection(email: String, username: String, userID: String , success: (() -> Void)?, failure: ((Error) -> Void)?) {
        let querySetup = database.collection("users").document(userID)
        let dataToSet: [String: Any] = ["email": email,
                                        "username": username,
                                        "userID": userID,
        ]
        querySetup.setData(dataToSet, completion: { error in
            guard let error else {
                success?()
                return
            }
            failure?(error)
        })
    }
}
