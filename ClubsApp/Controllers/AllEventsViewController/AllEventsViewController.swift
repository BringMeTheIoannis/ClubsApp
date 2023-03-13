//
//  AllEventsViewController.swift
//  ClubsApp
//
//  Created by Ivan Kuzmenkov on 13.02.23.
//

import UIKit
import SnapKit
import FirebaseFirestore

class AllEventsViewController: UIViewController {
    
    var isNeedToFetchMore: Bool = false
    var endOfDataToFetchReached: Bool = false
    let multiplierSpaceToStartBatching: CGFloat = 1.0
    
    
    var allEventsFromDB = [EventModel]() {
        didSet {
            allEventsFromDB.count == 0 ? (noDataErrorLabel.isHidden = false) : (noDataErrorLabel.isHidden = true)
        }
    }
    
    var queryDocuments = [DocumentSnapshot]()
    
    var filteredEventsToShowInTable = [EventModel]()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var noDataErrorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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
        navigationItem.title = "Мероприятия"
        navigationBarSetup()
    }
    
    private func navigationBarSetup() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(red: 0.94, green: 0.91, blue: 0.971, alpha: 1)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.compactAppearance = navBarAppearance
    }
    
    private func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllEventsTableViewCell.self, forCellReuseIdentifier: AllEventsTableViewCell.id)
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(noDataErrorLabel)
        view.addSubview(activityIndicator)
    }
    
    private func doLayout() {
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

        dbManager.getAllEvents(eventsDocumentSnapshots: queryDocuments) {[weak self] eventsArray in
            guard let self else { return }
            self.isNeedToFetchMore = false
            self.endOfDataToFetchReached = eventsArray.count == 0
            self.allEventsFromDB.append(contentsOf: eventsArray)
            self.filteredEventsToShowInTable.append(contentsOf: eventsArray)
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
        } failure: {[weak self] error in
            guard let self else { return }
            self.isNeedToFetchMore = false
            self.activityIndicator.stopAnimating()
            self.noDataErrorLabel.isHidden = false
            self.noDataErrorLabel.text = error
        } querySnapshotForPagination: { [weak self] documentsArray in
            guard let self else { return }
            self.queryDocuments.append(contentsOf: documentsArray)
        }
    }
    
    private func startToFetch() {
        isNeedToFetchMore = true
        getEvents()
    }
    
}

extension AllEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEventsToShowInTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllEventsTableViewCell.id, for: indexPath)
        guard let cell = cell as? AllEventsTableViewCell else { return cell }
        cell.label.text = "\(indexPath.row) \(filteredEventsToShowInTable[indexPath.row].title)"
        return cell
    }
    
}

extension AllEventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * multiplierSpaceToStartBatching {
            if !isNeedToFetchMore && !endOfDataToFetchReached {
                startToFetch()
            }
        }
    }
}
