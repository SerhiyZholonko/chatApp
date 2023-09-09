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
    let welcomeLabel = CustomLabel(textLabel: "HELLO, WELCOME", fontLabel: .boldSystemFont(ofSize: 20))
    private var profileImageView = CustomImageView(image: UIImage(named: "teamwork"), width: 50, height: 50)
    private let emailTF: CustomTextField = .init(placeholder: "Email", keyboardType: .emailAddress)
    private let passwordTF: CustomTextField = .init(placeholder: "Password", isSecureText: true)

    private lazy var loginButton = AuthButton(viewModel: viewModel, title: "Login")
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
    private let contLable = CustomLabel(textLabel: "or contiue with Google", textColorLabel: .lightGray)
    private lazy var googleButton: UIButton = {
          let button = UIButton(type: .system)
          button.setTitle("Google", for: .normal)
          button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tintColor = .label.complementaryColor()
          button.backgroundColor = .label
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
        buttonConfigure()
    }
    //MARK: - Functions
    private func buttonConfigure() {
        loginButton.delegate = self
    }
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
//MARK: -

extension LoginViewController: AuthButtonDelegate {
    @objc func handleLoginVC() {
        print("Login..")
    }
}
