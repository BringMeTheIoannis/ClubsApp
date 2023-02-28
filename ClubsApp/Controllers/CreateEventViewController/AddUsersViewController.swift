//
//  AddUsersViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 23.02.23.
//

import UIKit

class AddUsersViewController: UIViewController {
    
    var users = [User]()
    var addedUsersArray = [User]() {
        didSet {
            tableView.reloadData()
            addedUsersDataBringToCreateVC?(addedUsersArray)
        }
    }
    var database = DatabaseManager()
    var searchResultVC = SearchResultViewController()
    var addedUsersDataBringToCreateVC: (([User]) -> Void)?
    var charsThatAlreadyBeenQueried = [String]()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: searchResultVC)
        searchController.searchBar.placeholder = "Добавить участников"
        searchController.searchBar.tintColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1)
        searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        searchController.searchBar.autocapitalizationType = .none
        return searchController
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var closeVCImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "chevron.down")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeVC))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1)
        imageView.addGestureRecognizer(gesture)
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        controllerSetup()
        searchControllerSetup()
        tableViewSetup()
        addSubviews()
        doLayout()
    }
    
    private func controllerSetup() {
        view.backgroundColor = .white
        title = "Пригласите участников"
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeVCImage)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func searchControllerSetup() {
        searchController.searchResultsUpdater = self
    }
    
    private func tableViewSetup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.id)
    }
    
    private func addSubviews() {
        navigationItem.searchController = searchController
        view.addSubview(tableView)
    }
    
    private func doLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func closeVC() {
        self.dismiss(animated: true)
    }
}

extension AddUsersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased(),
              let resultVC = searchController.searchResultsController as? SearchResultViewController
        else { return }
        if text.count == 1, !charsThatAlreadyBeenQueried.contains(text) {
            charsThatAlreadyBeenQueried.append(text)
            resultVC.activityIndicator.startAnimating()
            database.getUsersByChars(name: text) {[weak self] arrayOfUsers in
                guard let self else { return }
                self.users.append(contentsOf: arrayOfUsers)
                resultVC.errorLabel.isHidden = true
                resultVC.searchResults = self.users.filter { $0.lowercasedName.contains(text) }
                resultVC.activityIndicator.stopAnimating()
                return
            } failure: { failure in
                resultVC.errorLabel.text = failure ?? ""
                resultVC.errorLabel.isHidden = false
                resultVC.activityIndicator.stopAnimating()
                return
            }
        }
        resultVC.errorLabel.isHidden = false
        resultVC.searchResults = users.filter { $0.lowercasedName.contains(text) }
        resultVC.dismissSearchController = {[weak self] addedUser in
            guard let self else { return }
            self.addedUsersArray.append(addedUser)
            searchController.isActive = false
        }
    }
}

extension AddUsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addedUsersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.id, for: indexPath)
        guard let cell = cell as? SearchResultTableViewCell else { return cell }
        cell.nameLabel.text = addedUsersArray[indexPath.row].name
        return cell
    }
}

extension AddUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
