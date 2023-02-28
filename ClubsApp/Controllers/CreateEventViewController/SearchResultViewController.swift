//
//  SearchResultViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 23.02.23.
//

import UIKit
import SnapKit

class SearchResultViewController: UIViewController {
    
    var searchResults = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    var dismissSearchController: ((User) -> Void)?
    
    var errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .red
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.tintColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Извините, ничего не найдено"
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegatesAndDataSource()
        registerCells()
        addSubviews()
        doLayout()
    }
    
    private func setDelegatesAndDataSource() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func registerCells() {
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.id)
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(noDataLabel)
        view.addSubview(errorLabel)
    }
    
    private func doLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(tableView)
        }
        
        noDataLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(50)
        }
    }
}

extension SearchResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.id, for: indexPath)
        guard let cell = cell as? SearchResultTableViewCell else { return cell }
        cell.nameLabel.text = searchResults[indexPath.row].name
        return cell
    }
}

extension SearchResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissSearchController?(searchResults[indexPath.row])
    }
}
