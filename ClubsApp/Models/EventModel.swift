//
//  EventModel.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 4.03.23.
//

import Foundation
import FirebaseFirestore

struct EventModel: Decodable {
    var title: String
    var date: Date
    var place: String
    var about: String
    var invitedUsers: [User]
    var picture: String
    var isClosedEvent: Bool
    
    
    init(title: String, date: Date, place: String, about: String, invitedUsers: [User], picture: String, isClosedEvent: Bool) {
        self.title = title
        self.date = date
        self.place = place
        self.about = about
        self.invitedUsers = invitedUsers
        self.picture = picture
        self.isClosedEvent = isClosedEvent
    }
    
    enum CodingKeys: CodingKey {
        case title
        case date
        case place
        case about
        case invitedUsers
        case picture
        case isClosedEvent
    }
}
