//
//  SelectedTextFieldProtocol.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 10.02.23.
//

import UIKit

protocol ViewControllerWithActiveTextFieldProtocol {
    var activeTextField: UITextField? { get set }
}
