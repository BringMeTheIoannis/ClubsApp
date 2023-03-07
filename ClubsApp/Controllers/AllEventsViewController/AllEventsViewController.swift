//
//  AllEventsViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 13.02.23.
//

import UIKit
import SnapKit

class AllEventsViewController: UIViewController {
    
    var allEventsFromDB = [EventModel]() {
        didSet {
            allEventsFromDB.count == 0 ? (noDataErrorLabel.isHidden = false) : (noDataErrorLabel.isHidden = true)
        }
    }
    
    var filteredEventsToShowInTable = [EventModel]()
    
    var topColorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.94, green: 0.91, blue: 0.971, alpha: 1)
        return view
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var noDataErrorLabel: UILabel = {
        let label = UILabel()
        label.text = "Пока что тут пусто"
        label.isHidden = true
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.tintColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        controllerSetup()
        addSubviews()
        doLayout()
        tableViewSetup()
        getEvents()
    }
    
    private func controllerSetup() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Мероприятия"
    }
    
    private func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllEventsTableViewCell.self, forCellReuseIdentifier: AllEventsTableViewCell.id)
    }
    
    private func addSubviews() {
        view.addSubview(topColorView)
        view.addSubview(tableView)
        view.addSubview(noDataErrorLabel)
        view.addSubview(activityIndicator)
    }
    
    private func doLayout() {
        topColorView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        view.bringSubviewToFront(topColorView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noDataErrorLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func getEvents() {
        let dbManager = DatabaseManager()
        activityIndicator.startAnimating()
        noDataErrorLabel.isHidden = true
        dbManager.getAllEvents {[weak self] eventsArray in
            guard let self else { return }
            self.allEventsFromDB = eventsArray
            self.filteredEventsToShowInTable = eventsArray
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        } failure: {[weak self] error in
            guard let self else { return }
            self.noDataErrorLabel.isHidden = false
            self.noDataErrorLabel.text = error
        }
    }
}

extension AllEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEventsToShowInTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllEventsTableViewCell.id, for: indexPath)
        guard let cell = cell as? AllEventsTableViewCell else { return cell }
        cell.label.text = filteredEventsToShowInTable[indexPath.row].title
        return cell
    }
    
    
}

extension AllEventsViewController: UITableViewDelegate {
    
}
