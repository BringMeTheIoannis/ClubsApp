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
    var isRefreshControlActive: Bool = false
    let multiplierSpaceToStartBatching: CGFloat = 1.0
    var allEventsFromDB = [EventModel]() {
        didSet {
            allEventsFromDB.count == 0 ? (noDataErrorLabel.isHidden = false) : (noDataErrorLabel.isHidden = true)
        }
    }
    var queryDocuments = [DocumentSnapshot]()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var noDataErrorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(callGetEvents(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controllerSetup()
        addSubviews()
        doLayout()
        tableViewSetup()
        getEvents(isInitCall: true)
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
        tableView.refreshControl = refreshControl
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
            make.leading.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(view.safeAreaLayoutGuide.snp.centerY)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func getEvents(isInitCall: Bool = false) {
        let dbManager = DatabaseManager()
        if isInitCall {
            if !isRefreshControlActive {
                activityIndicator.startAnimating()
            }
            endOfDataToFetchReached = false
            queryDocuments.removeAll()
        }
        noDataErrorLabel.isHidden = true
        
        dbManager.getAllEvents(eventsDocumentSnapshots: queryDocuments) {[weak self] eventsArray in
            guard let self else { return }
            self.isNeedToFetchMore = false
            self.endOfDataToFetchReached = eventsArray.count == 0
            if isInitCall {
                self.allEventsFromDB = eventsArray
                self.activityIndicator.stopAnimating()
                
            } else {
                self.allEventsFromDB += eventsArray
            }
            self.tableView.tableFooterView = nil
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
            self.isRefreshControlActive = false
        } failure: {[weak self] error in
            guard let self else { return }
            self.isNeedToFetchMore = false
            self.isRefreshControlActive = false
            if isInitCall {
                self.activityIndicator.stopAnimating()
            }
            self.tableView.tableFooterView = nil
            self.noDataErrorLabel.isHidden = false
            self.noDataErrorLabel.text = error
        } querySnapshotForPagination: { [weak self] documentsArray in
            guard let self else { return }
            self.queryDocuments.append(contentsOf: documentsArray)
        }
    }
    
    @objc private func callGetEvents(sender: UIRefreshControl) {
        if isRefreshControlActive {
            return
        }
        isRefreshControlActive = true
        getEvents(isInitCall: true)
    }
    
    private func startToFetch() {
        isNeedToFetchMore = true
        getEvents()
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        let inCellActivityIndicator = UIActivityIndicatorView()
        inCellActivityIndicator.tintColor = UIColor(red: 0.498, green: 0.02, blue: 0.976, alpha: 1)
        inCellActivityIndicator.hidesWhenStopped = true
        
        footerView.addSubview(inCellActivityIndicator)
        inCellActivityIndicator.snp.makeConstraints { make in
            make.center.equalTo(footerView.snp.center)
        }
        
        inCellActivityIndicator.startAnimating()
        return footerView
    }
    
    private func slicePersonNameBy15CharIfNeeded(name: String) -> String {
        if name.count > 15 {
            return String(name.prefix(15))
        } else {
            return name
        }
    }
    
    private func participationTextDependsOfQuantity(quantity: Int) -> String {
        if quantity == 1 {
            return "учавствует"
        } else {
            return "+ \(quantity - 1) участников(-а)"
        }
    }
}

extension AllEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEventsFromDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllEventsTableViewCell.id, for: indexPath)
        guard let cell = cell as? AllEventsTableViewCell else { return cell }
        let firstInvitedPerson = allEventsFromDB[indexPath.row].invitedUsers.first
        let firstUserColor = UIColor(hex: firstInvitedPerson?.imageColor ?? "")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        
        cell.eventEmojiLabel.text = allEventsFromDB[indexPath.row].picture
        cell.titleLabel.text = allEventsFromDB[indexPath.row].title
        cell.participantImageView.backgroundColor = firstUserColor ?? .white
        cell.firstCharOnImageLabel.text = String(firstInvitedPerson?.name.prefix(1) as? Substring ?? "")
        if let firstInvitedPerson {
            let personName = firstInvitedPerson.name
            let invitedUsersCount = allEventsFromDB[indexPath.row].invitedUsers.count
            var personNameToShow = slicePersonNameBy15CharIfNeeded(name: personName)
            var quantityTextToShow = participationTextDependsOfQuantity(quantity: invitedUsersCount)
            cell.quantityOfParticipantsLabel.text = ("\(personNameToShow) \(quantityTextToShow)")
        } else {
            cell.quantityOfParticipantsLabel.text = "Участников пока нет"
        }
        
        cell.dateLabel.text = dateFormatter.string(from: allEventsFromDB[indexPath.row].date)
        
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
                tableView.tableFooterView = createSpinnerFooter()
                startToFetch()
            }
        }
    }
    
}
