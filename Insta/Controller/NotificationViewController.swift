//
//  NotificationViewController.swift
//  Insta
//
//  Created by AriChou on 2/3/21.
//

import UIKit

private let cellReuseIdentifier = "notificationCell"

class NotificationViewController: UITableViewController {

    // MARK: = Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - COnfigure UI
extension NotificationViewController {
    private func configureUI() {
        navigationItem.title = "Notofication"
        view.backgroundColor = .white
//      tableView.register(NotificationCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.register(UINib(nibName: "AATableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
}

// MARK: -
extension NotificationViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! AATableViewCell
        return cell
    }
}
