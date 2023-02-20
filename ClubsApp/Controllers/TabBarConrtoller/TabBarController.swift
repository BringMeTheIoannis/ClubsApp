//
//  TabBarController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 13.02.23.
//

import UIKit
import FirebaseAuth

class TabBarController: UITabBarController {
    
    let allEventsViewController = AllEventsViewController()
    let likedInvitedViewController = LikedInvitedViewController()
    let createEventViewController = CreateEventViewController()
    let chatsViewController = ChatsViewController()
    let profileSettingsViewController = ProfileSettingsViewController()
    var tabBarIndicatorView: UIView = {
       let view = UIView()
        return view
    }()
    let tintColor = UIColor(red: 127/255, green: 5/255, blue: 249/255, alpha: 1.0)
    let tabBarBackgroundColor = UIColor(red: 240/255, green: 232/255, blue: 248/255, alpha: 1.0)
    var indicatorSpacing: CGFloat = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarBasicSetup()
        configureControllers()
        configureTabBarIcons()
        setupDelegate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addTabbarIndicatorInitCall()
    }
    
    private func tabBarBasicSetup() {
        tabBar.backgroundColor = tabBarBackgroundColor
        tabBar.tintColor = tintColor
        tabBar.itemPositioning = .centered
        selectedIndex = 0
    }
    
    private func setupDelegate() {
        delegate = self
    }
    
    private func configureTabBarIcons() {
        let bar1 = UITabBarItem(title: nil, image: UIImage(systemName: "square.grid.2x2"), selectedImage: UIImage(systemName: "square.grid.2x2.fill"))
        let bar2 = UITabBarItem(title: nil, image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        let bar3 = UITabBarItem(title: nil, image: UIImage(systemName: "plus.square.fill"), selectedImage: UIImage(systemName: "plus.square.fill"))
        let bar4 = UITabBarItem(title: nil, image: UIImage(systemName: "bubble.middle.bottom"), selectedImage: UIImage(systemName: "bubble.middle.bottom.fill"))
        let bar5 = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), selectedImage: UIImage(systemName: "person.circle.fill"))
        allEventsViewController.tabBarItem = bar1
        likedInvitedViewController.tabBarItem = bar2
        createEventViewController.tabBarItem = bar3
        chatsViewController.tabBarItem = bar4
        profileSettingsViewController.tabBarItem = bar5
    }
    
    private func configureControllers() {
        let wNavigationAllEventsViewController = UINavigationController(rootViewController: allEventsViewController)
        let wNavigationLikedInvitedViewController = UINavigationController(rootViewController: likedInvitedViewController)
        let wNavigationChatsViewController = UINavigationController(rootViewController: chatsViewController)
        let wNavigationProfileSettingsViewController = UINavigationController(rootViewController: profileSettingsViewController)
        viewControllers = [wNavigationAllEventsViewController, wNavigationLikedInvitedViewController, createEventViewController, wNavigationChatsViewController, wNavigationProfileSettingsViewController]
    }
    
    private func addTabbarIndicatorInitCall() {
        DispatchQueue.main.async {[weak self] in
            guard let self else { return }
            self.addTabbarIndicator(index: self.selectedIndex, isInitIndicator: true)
        }
    }
        
    private func addTabbarIndicator(index: Int, isInitIndicator: Bool = false) {
        guard let tabView = tabBar.items?[index].value(forKey: "view") as? UIView else { return }
        if !isInitIndicator {
            tabBarIndicatorView.removeFromSuperview()
        }
        tabBarIndicatorView = UIView(frame: CGRect(x: tabView.frame.minX + indicatorSpacing, y: tabView.frame.minY - 1, width: tabView.frame.size.width - indicatorSpacing * 2, height: 4))
        tabBarIndicatorView.backgroundColor = tintColor
        tabBar.addSubview(tabBarIndicatorView)
    }
    
    private func openCreateScreen() {
        let vc = UINavigationController(rootViewController: CreateEventViewController())
        vc.navigationBar.prefersLargeTitles = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        addTabbarIndicator(index: selectedIndex)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is CreateEventViewController {
            openCreateScreen()
            return false
        }
        return true
    }
}

