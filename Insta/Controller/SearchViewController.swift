//
//  SearchViewController.swift
//  Insta
//
//  Created by AriChou on 2/3/21.
//

import UIKit

private let cellID = "cellID"

class SearchViewController: UITableViewController {

    // MARK: - Properties
    private var users: [User] = []
    var filterUsers: [User] = []
    private var isInSearchModel: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: = Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchVC()
        tableView.backgroundColor = .white
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = "Search"
        tableView.rowHeight = 64
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: cellID)
        fetchUer()
    }
}

// MARK: - Configure UI
extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isInSearchModel ? filterUsers.count : users.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserTableViewCell
        let user = isInSearchModel ? filterUsers[indexPath.row] : users[indexPath.row]
        cell.viewModel = UserCellViewModel(user: user)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = isInSearchModel ? filterUsers[indexPath.row] : users[indexPath.row]
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Configure Search Controller
extension SearchViewController: UISearchResultsUpdating {
    func configureSearchVC() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filterUsers = users.filter({$0.username.contains(searchText)})
        self.tableView.reloadData()
    }
}

// MARK: - Fetch User
extension SearchViewController {
    func fetchUer() {
        UserService.fetchAllUsers { (users) in
            self.users = users
            self.tableView.reloadData()
        }
    }
}
