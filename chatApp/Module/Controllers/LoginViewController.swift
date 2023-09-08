//
//  LoginViewController.swift
//  chatApp
//
//  Created by apple on 08.09.2023.
//

import UIKit


class LoginViewController: UIViewController {
    //MARK: - Properties
    
    var viewModel = LoginViewModel()
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "HEY, WELCOME"
        label.font = .boldSystemFont(ofSize: 20)
        label.tintColor = .label
        return label
    }()
    private var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "profile")
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(height: 50, width: 50)
        return iv
    }()
    private let emailTF: UITextField = {
        let tf = UITextField()
        tf.tintColor = .label
        tf.backgroundColor = .secondarySystemBackground
        tf.setHeight (50)
        tf.placeholder = "Email"
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        tf.leftViewMode = .always
        tf.leftView = leftView
        tf.layer.cornerRadius = 6
        tf.keyboardType = .emailAddress
        return tf
    }()
    private let passwordTF: UITextField = {
        let tf = UITextField()
        tf.tintColor = .label
        tf.backgroundColor = .secondarySystemBackground
        tf.setHeight (50)
        tf.placeholder = "Password"
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        tf.leftViewMode = .always
        tf.leftView = leftView
        tf.layer.cornerRadius = 6
        tf.isSecureTextEntry = true
        return tf
    }()
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 19)
        button.tintColor = .white
        button.backgroundColor = viewModel.backgroundColor
        button.setTitleColor(viewModel.titleColor, for: .normal)
        button.setHeight(50)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleLoginVC), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    private lazy var forgetPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label

        button.setAttributedTitle(regularText: "Forget your password? ", boldText: "Get Help Signing in", fontSize: 17)

        button.addTarget(self, action: #selector(handleForgetPassword), for: .touchUpInside)
        return button
    }()
    private lazy var dontHeveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label

        button.setAttributedTitle(regularText: "Don't have an accout? ", boldText: "Sign up",fontSize: 16)

        button.addTarget(self, action: #selector(handleForgetPassword), for: .touchUpInside)
        button.setHeight(50)
        button.addTarget(self, action: #selector(handleDontHeveAccountButton), for: .touchUpInside)
        return button
    }()
    private let contLable: UILabel = {
        let label = UILabel()
        label.text = "or contiue with Google"
        label.textColor = .lightGray
        return label
    }()
    private lazy var googleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Google", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .black
        button.setHeight(50)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleGoogleSignIn), for: .touchUpInside)
        return button
    }()
    //MARK: - Lilecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureForTextFeild()
    }
    //MARK: - Functions
    private func configureUI() {
        view.backgroundColor = .systemBackground
        addConstraints()
    }
    private func addConstraints() {
        view.addSubview(welcomeLabel)
        welcomeLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        welcomeLabel.centerX(inView: view)
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: welcomeLabel.bottomAnchor, paddingTop: 20)
        profileImageView.centerX(inView: view)
        
        let stackView = UIStackView(arrangedSubviews: [
            emailTF, passwordTF, loginButton, forgetPasswordButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        stackView.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        view.addSubview(dontHeveAccountButton)
        dontHeveAccountButton.anchor( bottom: view.safeAreaLayoutGuide.bottomAnchor)
        dontHeveAccountButton.centerX(inView: view)
        view.addSubview(contLable)
        contLable.anchor(top: stackView.bottomAnchor, paddingTop: 40)
        contLable.centerX(inView: view)
        view.addSubview(googleButton)
        googleButton.anchor(top: contLable.bottomAnchor, paddingTop: 12, width: 150)
        googleButton.centerX(inView: contLable)
    }
    private func configureForTextFeild(){
    emailTF.addTarget(self, action: #selector (handleTextChanged (sender:)) , for:
            .editingChanged)
    passwordTF.addTarget(self, action: #selector (handleTextChanged (sender:)), for:
            .editingChanged)
                      }
    //MARK: - OBJC func
    
    @objc private func handleLoginVC() {
        
    }
    @objc private func handleForgetPassword() {
        
    }
    @objc private func handleDontHeveAccountButton() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func  handleGoogleSignIn() {
        
    }
    @objc private func handleTextChanged(sender: UITextField) {
        sender == emailTF ? (viewModel.email = sender.text) : (viewModel.password = sender.text)
        updateForm()
    }
    private func updateForm() {
        loginButton.isEnabled = viewModel.formIsFaild
        loginButton.backgroundColor = viewModel.backgroundColor
        loginButton.setTitleColor(viewModel.titleColor, for:.normal)
    }
}
