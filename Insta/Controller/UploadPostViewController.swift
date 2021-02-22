//
//  UploadPostViewController.swift
//  Insta
//
//  Created by AriChou on 2/8/21.
//

import UIKit

protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploadPost(_ controller: UploadPostViewController)
}

class UploadPostViewController: UIViewController {

    
    // MARK: - Properties
    weak var delegate: UploadPostControllerDelegate?
    
    var currentUser: User?
    
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    
    private let photoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private lazy var captionTextView: InputTextView = {
       let textView = InputTextView()
        textView.placeholderText = "Enter Caption..."
        textView.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        textView.delegate = self
        return textView
    }()
    
    private let characterCountLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .right
        label.text = "1/100"
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
}

// MARK: - Configure UI
extension UploadPostViewController {
    
    func configureUI() {
        navigationItem.title = "Upload Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(didTappedShareButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTappedCancelButton))
        
        view.addSubview(photoImageView)
        view.addSubview(captionTextView)
        view.addSubview(characterCountLabel)
        
        for view in view.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            photoImageView.heightAnchor.constraint(equalToConstant: 124),
            photoImageView.widthAnchor.constraint(equalToConstant: 124),
            photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            captionTextView.topAnchor.constraint(equalTo: photoImageView.topAnchor),
            captionTextView.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20),
            captionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            characterCountLabel.topAnchor.constraint(equalTo: captionTextView.bottomAnchor),
            characterCountLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 20),
            characterCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            characterCountLabel.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor)
        ])
    }
}

// MARK: - Text View Delegate
extension UploadPostViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        checkMaxLength(textView)
        characterCountLabel.text = "\(count)/100"
    }
    
    private func checkMaxLength(_ textView: UITextView) {
        if textView.text.count > 100 {
            textView.deleteBackward()
        }
    }
}


// MARK: - UI Action
extension UploadPostViewController {
    
    @objc func didTappedCancelButton() {
        self.delegate?.controllerDidFinishUploadPost(self)
    }
    
    @objc func didTappedShareButton() {
        showLoader(true)
        guard let caption = captionTextView.text else { return }
        guard let selectedImage = selectedImage else { return }
        guard let user = currentUser else { return }
        
        PostService.uploadPost(caption: caption, image: selectedImage, user: user) { (error) in
            self.showLoader(false)
            if let error = error {
                print("用户发布动态失败", error.localizedDescription)
                return
            }
            self.delegate?.controllerDidFinishUploadPost(self)
        }
    }
}
