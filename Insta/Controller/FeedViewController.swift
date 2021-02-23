//
//  FeedViewController.swift
//  Insta
//
//  Created by AriChou on 2/3/21.
//

import UIKit

private let cellIdentifider = "cell"

class FeedViewController: UICollectionViewController {
    
    // MARK: - Properties
    var posts: [Post] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // This post data is from profile cell selected
    var post: Post?
    

    // MARK: = Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
        configureRefresher()
    }

}

// MARK: - Configure UI
extension FeedViewController {
    
    func configureUI() {
        collectionView.backgroundColor = .white
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logo"), style: .plain, target: nil, action: nil)
        }
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellIdentifider)
    }
}

// MARK: Configure Collection View
extension FeedViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifider, for: indexPath) as! FeedCell
        
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
            return cell
        } else {
             cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        
        cell.delagate = self
        return cell
    }
}

// MARK: Collection View Flow Layout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        var height = width + 170
        return CGSize(width: width, height: height)
    }
}

// MARK: - Fetch Posts
extension FeedViewController {
    private func fetchPosts() {
        PostService.fetchPosts { (posts) in
            print("获取所有Posts成功")
            self.posts = posts
            self.collectionView.refreshControl?.endRefreshing()
            self.checkIfUserLikedPost()
            self.collectionView.reloadData()
        }
    }
}


// MARK: - Refresh Controller
extension FeedViewController {
    func configureRefresher() {
        let refrsher = UIRefreshControl()
        refrsher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refrsher
    }
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
}


// MARK: - Check If User Liked Post
extension FeedViewController {
    func checkIfUserLikedPost() {
        self.posts.forEach { (post) in
            PostService.checkIfUserLikedThePost(post: post) { (didLike) in
                print("用户点赞过该条Post\(post.postId), \(didLike)")
                if let index = self.posts.firstIndex(where: {$0.postId == post.postId}) {
                    return self.posts[index].didLike = didLike
                }
            }
        }
    }
}


// MARK: - FeedCellDelegate

extension FeedViewController: FeedCellDelegate {
    
    func cell(_ cell: FeedCell, wantsTosShowProfile uid: String) {
        UserService.fetchCurrentUser(forUid: uid) { (user) in
            let vc = ProfileViewController(user: user)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowController post: Post) {
        let vc = CommentCollectionViewController(post: post)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        cell.viewModel?.post.didLike.toggle()
        let tab = self.tabBarController as! MainTabViewController
        guard let user = tab.user else { return }
        
        if post.didLike {
            print("unlike")
            PostService.unLikePost(post: post) { (_) in
                print("您不喜欢了该Post，Post like 数减一")
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            PostService.likePost(post: post) { (_) in
                print("您喜欢了该Post，Post like 数加一")
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationService.uploadNotification(toUid: post.ownerUid, fromUser: user, type: .like, post: post)
            }
        }
    }
}
