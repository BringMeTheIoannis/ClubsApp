//
//  Wrappers.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 8.02.23.
//

import Foundation

extension Optional where Wrapped == String {
    var unwrapped: String {
        return self ?? ""
    }
}
