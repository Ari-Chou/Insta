//
//  CommentCollectionViewController.swift
//  Insta
//
//  Created by AriChou on 2/11/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class CommentCollectionViewController: UICollectionViewController {

    // MARK: - Properties
    
    private let post: Post
    
    var comments = [Comment]()
    
    private lazy var inputContainerView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let tv = CommentInputAccesoryView(frame: frame)
        tv.delegate = self
        return tv
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Comment"
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        fetchComments()
    }
    
    override var inputAccessoryView: UIView? {
        get{ return inputContainerView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    init(post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - API
    private func fetchComments() {
        CommentService.fetchComment(forPost: post.postId) { (commets) in
            self.comments = commets
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CommentCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = comments[indexPath.row].uid
        UserService.fetchCurrentUser(forUid: uid) { (user) in
            let vc = ProfileViewController(user: user)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CommentCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}


// MARK: - CommentInputAccesoryViewDelegate
extension CommentCollectionViewController: CommentInputAccesoryViewDelegate {
    
    func inputView(_ iputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
        guard let tab = self.tabBarController as? MainTabViewController else { return }
        guard let user = tab.user else { return }
        self.showLoader(true)
        
        CommentService.uploadComment(comment: comment, postID: post.postId, user: user) { (error) in
            if let error = error {
                print("发表评论失败", error.localizedDescription)
            }
            print("发表评论成功并清理输入框")
            iputView.clearCommentTextView()
            self.showLoader(false)
        }
    }
}



