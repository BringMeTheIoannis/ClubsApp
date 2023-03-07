//
//  UserModel.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 27.02.23.
//

import Foundation

struct User: Codable {
    var name: String
    var email: String?
    var id: String
    var lowercasedName: String
    var imageColor: String
    var isUserAddedForEvent = false
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case email = "email"
        case id = "userID"
        case lowercasedName = "lowercasedUserName"
        case imageColor = "imageColor"
    }
}
