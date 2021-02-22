//
//  MainTabViewController.swift
//  Insta
//
//  Created by AriChou on 2/3/21.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabViewController: UITabBarController {
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewController(user: user)
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        checkIfUserIsLoggedIn()
        self.delegate = self
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginVC = LoginViewController()
                loginVC.delegate = self
                let nav = UINavigationController(rootViewController: loginVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - Configure UI
extension MainTabViewController {
    
    func configureViewController(user: User) {
        let layout = UICollectionViewFlowLayout()
        
        let feedVC = templateNavigationController(rootViewController: FeedViewController(collectionViewLayout: layout), imageName: "house.fill")
        let searchVC = templateNavigationController(rootViewController: SearchViewController(), imageName: "magnifyingglass")
        let imageSelectVC = templateNavigationController(rootViewController: ImageSelectViewController(), imageName: "plus.square")
        let notificationVC = templateNavigationController(rootViewController: NotificationViewController(), imageName: "heart.fill")
        let profileVC = templateNavigationController(rootViewController: ProfileViewController(user: user), imageName: "person.fill")
        
        viewControllers = [feedVC, searchVC, imageSelectVC, notificationVC, profileVC]
    }
    
    func templateNavigationController(rootViewController: UIViewController ,imageName: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = UIImage(systemName: imageName)
        nav.navigationBar.tintColor = .black
        tabBar.tintColor = .black
        return nav
    }
}

// MARK: - Fetch User
extension MainTabViewController: Authenticationdelegate {
    func authenticationDidComplete() {
        print("登陆成功后再次fetchUser并dimiss")
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}

extension MainTabViewController {
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.fetchCurrentUser(forUid: uid) { (user) in
            self.user = user
        }
    }
}


// MARK: - UITabBar Controller Delegate
extension MainTabViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesBottomBar = false
            config.hidesStatusBar = false
            config.library.maxNumberOfItems = 1

            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickingMedia(picker)
        }
        return true
    }
    
  
    
    private func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { (items, _) in
            picker.dismiss(animated: true) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                let vc = UploadPostViewController()
                vc.selectedImage = selectedImage
                vc.delegate = self
                vc.currentUser = self.user
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
                
            }
        }
    }
}

// MARK: - UploadPostControllerDelegate
extension MainTabViewController: UploadPostControllerDelegate {
    func controllerDidFinishUploadPost(_ controller: UploadPostViewController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        guard let feedVC = feedNav.viewControllers.first as? FeedViewController else { return }
        feedVC.handleRefresh()
    }
}
