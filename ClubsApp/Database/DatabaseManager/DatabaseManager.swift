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
                                        "name": username,
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
    
    func getUsersByChars(name: String, success: (([User]) -> Void)?, failure: ((String?) -> Void)?) {
        let querySetup = database.collection("users").whereField("name", isGreaterThanOrEqualTo: name)
        querySetup.getDocuments { querySnapshot, error in
            guard let querySnapshot, error == nil else {
                failure?(error?.localizedDescription)
                return
            }
            let arrayOfDocuments = querySnapshot.documents
            let decoder = JSONDecoder()
            var users: [User] = arrayOfDocuments.compactMap { queryDocumentSnapshot in
                if let jsonObject = try? JSONSerialization.data(withJSONObject: queryDocumentSnapshot.data()),
                   let userObject = try? decoder.decode(User.self, from: jsonObject) {
                    return userObject
                }
                return nil
            }
            success?(users)
        }
    }
}
