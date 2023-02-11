//
//  ScendeDelegateEnvironment.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 8.02.23.
//

import UIKit

class SceneDelegateEnvironment {
    static var sceneDelegate: SceneDelegate? {
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        return scene
    }
}
