//
//  DatabaseManager.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 10.02.23.
//

import Foundation
import FirebaseFirestore


class DatabaseManager {
    let database = Firestore.firestore()
    
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
}
