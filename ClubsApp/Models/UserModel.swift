//
//  UserModel.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 27.02.23.
//

import Foundation

struct User: Codable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case email = "email"
        case id = "userID"
    }
    
    var name: String
    var email: String?
    var id: String
}
