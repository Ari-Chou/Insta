//
//  ViewController.swift
//  Instagram
//
//  Created by AriChou on 2/1/21.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    private var viewModel = SignUpViewModel()
    private var profileImage: UIImage?
    weak var delegate: Authenticationdelegate?
    
    // MARK: - UI Element
    lazy var plusPhotoButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 50
        button.layer.masksToBounds = true
        button.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    lazy var emailTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftView = spaceView
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var usernameTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "UserName"
        tf.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftView = spaceView
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftView = spaceView
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 5
        return tf
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SignUp", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = darkBlue
        button.layer.cornerRadius = 5
        button.isEnabled = false
        return button
    }()
    
    lazy var stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
    
    // MARK: - Element Action
    @objc func handlePlusButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.modalPresentationStyle = .fullScreen
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let originalImage = info[.originalImage] as? UIImage {
            profileImage = originalImage
        } else if let editedImage = info[.editedImage] as? UIImage {
            profileImage = editedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Text Field Action
    @objc func handletextFieldChanged(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == usernameTextField {
            viewModel.username = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        signUpButton.backgroundColor = viewModel.buttonColor
        signUpButton.isEnabled = viewModel.buttonIsEnable
    }
    
    // MARK: Sign Button Action
    @objc func handleSignButton() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text?.lowercased(), username.count > 0  else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        guard let profileImage = profileImage else { return }
        
        let credentials = AuthCredentials(email: email, username: username, password: password, prrofileImage: profileImage)
        
        AuthService.registerUser(withCredentials: credentials) { (error) in
            if let error = error {
                print("创建新用户并存储用户信息失败", error.localizedDescription)
                return
            }
            print("创建新用户并存储用户信息成功")
            self.delegate?.authenticationDidComplete()
        }
        
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Setup UI
extension SignUpViewController {
    
    fileprivate func setUpUI() {
        
        view.addSubview(plusPhotoButton)
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        
        for view in view.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            plusPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            plusPhotoButton.widthAnchor.constraint(equalToConstant: 100),
            plusPhotoButton.heightAnchor.constraint(equalToConstant: 100),
            plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            stackView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        //MARK: Element Action Target
        plusPhotoButton.addTarget(self, action: #selector(handlePlusButton), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignButton), for: .touchUpInside)
        emailTextField.addTarget(self, action: #selector(handletextFieldChanged), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(handletextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handletextFieldChanged), for: .editingChanged)
    }
}

