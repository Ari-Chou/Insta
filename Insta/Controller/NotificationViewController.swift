//
//  NotificationViewController.swift
//  Insta
//
//  Created by AriChou on 2/3/21.
//

import UIKit

private let cellReuseIdentifier = "notificationCell"

class NotificationViewController: UITableViewController {
    
    // MARK: - Properties
    var notofocations: [Notification] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: = Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchNotifications()
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

// MARK: - TableViewDelegate
extension NotificationViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notofocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: notofocations[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("............")
    }
    
    
}


// MARK: - API
extension NotificationViewController {
    func fetchNotifications() {
        NotificationService.fetchNotification { (notifications) in
            self.notofocations = notifications
        }
    }
}


// MARK: - NotificationCellDelegate
extension NotificationViewController: NotificationCellDelegate {
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        PostService.fetchSinglePost(withPostId: postId) { (post) in
            let vc = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
            vc.post = post
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
