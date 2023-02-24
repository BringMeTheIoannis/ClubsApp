//
//  AddUsersViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 23.02.23.
//

import UIKit

class AddUsersViewController: UIViewController {
    
    var users = ["Dima", "Kirill", "Klimnet", "Daryi"]
    var searchResultVC = SearchResultViewController()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultVC)
        searchController.searchBar.placeholder = "Добавить участников"
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        controllerSetup()
        searchControllerSetup()
        addSubviews()
        doLayout()
    }
    
    private func controllerSetup() {
        view.backgroundColor = .white
        title = "Пригласите участников"
    }
    
    private func searchControllerSetup() {
        searchController.searchResultsUpdater = self
    }
    
    private func addSubviews() {
        navigationItem.searchController = searchController
    }
    
    private func doLayout() {
        
    }
}

extension AddUsersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
              let resultVC = searchController.searchResultsController as? SearchResultViewController
        else { return }
        resultVC.names = users.filter({ $0.contains(text) })
        resultVC.dismissSearchController = {
            searchController.isActive = false
        }
    }
}
