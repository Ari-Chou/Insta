//
//  LoginViewController.swift
//  Instagram
//
//  Created by AriChou on 2/2/21.
//

import UIKit

protocol Authenticationdelegate: class {
    func authenticationDidComplete()
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel = LoginViewModel()
    
    weak var delegate: Authenticationdelegate?
    
    //MARK: - UI Element
    lazy var logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    
    lazy var emailTextField: UITextField = {
       let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftView = spaceView
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 5
        tf.keyboardType = .emailAddress
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
    
    lazy var resetPasswordButton: UIButton = {
       let button = UIButton()
        button.setTitle("Forget password?", for: .normal)
        button.setTitleColor(darkBlue, for: .normal)
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.backgroundColor = darkBlue
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.isEnabled = false
        return button
    }()
    
    lazy var toSignUpView: UILabel = {
       let label = UILabel()
        let attributeText = NSMutableAttributedString(string: "Don't have a account?", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular)])
        attributeText.append(NSAttributedString(string: "Sign up", attributes: [NSAttributedString.Key.foregroundColor: darkBlue]))
        label.attributedText = attributeText
        return label
    }()
    
    lazy var formStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, resetPasswordButton, loginButton])
    
    //MARK: - Element Action
    @objc func handleTextChanged(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        loginButton.backgroundColor =  viewModel.buttonColor
        loginButton.isEnabled = viewModel.buttonIsEnable
    }
    
    @objc func handleLoginButton() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        
        AuthService.loguserIn(email: email, password: password) { (authresult, error) in
            if let error = error {
                print("用户登陆失败", error.localizedDescription)
                return
            }
            print("用户登陆成功")
            self.delegate?.authenticationDidComplete()
        }
    }
    

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        addGestureRecognizerLabel()
        elementTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

//MARK: - Setup UI
extension LoginViewController {
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(formStackView)
        view.addSubview(toSignUpView)
        
        formStackView.axis = .vertical
        formStackView.distribution = .fillEqually
        formStackView.spacing = 15
        
        for view in view.subviews {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 170),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 182),
            logoImageView.heightAnchor.constraint(equalToConstant: 49),
            
            formStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            formStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            formStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            formStackView.heightAnchor.constraint(equalToConstant: 250),
            
            toSignUpView.topAnchor.constraint(equalTo: formStackView.bottomAnchor, constant: 30),
            toSignUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
}

//MARK: UI Action
extension LoginViewController {
    private func addGestureRecognizerLabel() {
        let gestureRecognizer = UITapGestureRecognizer()
        gestureRecognizer.numberOfTapsRequired = 1
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.addTarget(self, action: #selector(handleToSignUpView))
        toSignUpView.addGestureRecognizer(gestureRecognizer)
        toSignUpView.isUserInteractionEnabled = true
    }
    
    @objc func handleToSignUpView() {
        let vc = SignUpViewController()
        vc.delegate = delegate
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: Element Action Target
    private func elementTarget() {
        emailTextField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(handleTextChanged), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
    }
}
