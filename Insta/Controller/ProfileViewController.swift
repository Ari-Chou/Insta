//
//  ProfileViewController.swift
//  Insta
//
//  Created by AriChou on 2/3/21.
//

import UIKit
import Firebase
import SDWebImage


private let headerIdentifier = "headerID"
private let cellIdentifier = "cellID"

class ProfileViewController: UICollectionViewController {

    // MARK: - Properties
    
    var user: User
    var posts: [Post] = []
     
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPostsBelongSomeone()
    }
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure UI

extension ProfileViewController {
    private func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        navigationItem.title = user.username
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(handleSettingButton))
    }
}

// MARK: Header

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        header.viewModel = ProfileHeaderViewModel(user: user)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}

// MARK: Cell

extension ProfileViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: posts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        vc.post = posts[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: UI Action

extension ProfileViewController {
    @objc func handleSettingButton() {
        let alertController = UIAlertController(title: "Log Out", message: "Are you sure?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { (_) in
            self.logoutFromFirebase()
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func logoutFromFirebase() {
        do {
            try Auth.auth().signOut()
            let vc = LoginViewController()
            vc.delegate = self.tabBarController as? MainTabViewController
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        } catch let error as NSError {
            print("用户退出登陆失败", error.localizedDescription)
            return
        }
    }
}


// MARK: - Profile Header Delegate

extension ProfileViewController: ProfileHeaderDelegate {
    
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        if user.isCurrentUser {
            print("页面为当前登陆用户主页")
        } else if user.isFollowed {
            print("您已经关注了该用户")
            UserService.unFollow(uid: user.uid) { (error) in
                self.user.isFollowed = false
                self.collectionView.reloadData()
            }
        } else {
            print("您未关注该用户")
            UserService.follow(uid: user.uid) { (error) in
                self.user.isFollowed = true
                self.collectionView.reloadData()
            }
        }
    }
}


// MARK: - Check If User Is Followed
extension ProfileViewController {
    private func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { (isFollowed) in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Check User Stats
extension ProfileViewController {
    private func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { (userStats) in
            self.user.stats = userStats
            self.collectionView.reloadData()
            print(userStats)
        }
    }
}


// MARK: - Fetch Posts Belong Someone
extension ProfileViewController {
    private func fetchPostsBelongSomeone() {
        PostService.fetchPosts(forUser: user.uid) { (posts) in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
}
