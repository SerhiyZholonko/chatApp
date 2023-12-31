//
//  LoginViewController.swift
//  chatApp
//
//  Created by apple on 08.09.2023.
//

import UIKit
import GoogleSignIn
import Firebase


class LoginViewController: UIViewController, UIAnimatable {
    //MARK: - Properties
    var viewModel = LoginViewModel()
    let welcomeLabel = CustomLabel(textLabel: "WELCOME", fontLabel: .boldSystemFont(ofSize: 20))
    private var profileImageView = CustomImageView(image: UIImage(systemName: "person.fill"), width: 50, height: 50, tintColor: .systemGreen)
    private let emailTF: CustomTextField = .init(placeholder: "Email", keyboardType: .emailAddress, bourderColor: .systemGreen, bourderWight: 2)
    private let passwordTF: CustomTextField = .init(placeholder: "Password", isSecureText: true, bourderColor: .systemGreen, bourderWight: 2)
    
    private lazy var loginButton = AuthButton(viewModel: viewModel, title: "Login", bourderColor: .systemGreen, bourderWight: 2)
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
    private lazy var googleButton: ImageTextButton = {
        let button = ImageTextButton(imageName: "google", title: "Google", bourderColor: .systemGreen, bourderWight: 2)
        button.setHeight(50)
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
        guard let email = emailTF.text,
              let password = passwordTF.text else { return }
        AuthService.loginUser(withEmail: email, withPassword: password){[weak self] _, error in
            if let error = error {
                self?.errorLoadingAnimation(error: error.localizedDescription)
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else {return}
            UserServiece.fetchUser(uid: uid) { user in
                let vc = ConversationViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
                self?.succeedLoadingAnimation()
            }
        }
    }
}


//MARK: - google

extension LoginViewController {
    @objc private func  handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase authentication error: \(error.localizedDescription)")
                    return
                } else {
                    guard let authResult = authResult, let email = authResult.user.email, let username =  authResult.user.displayName?.firstWord(), let fullname = authResult.user.displayName, let url = authResult.user.photoURL  else { return }
                    // google Image
                    FileUploader.getImage(withImageURL: url) { image in
                        AuthService.signUpInGoogle(username: username, email: email, fullname: fullname, image: image, uid: authResult.user.uid) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                   
                }
                self.succeedLoadingAnimation()
                let scene = UIApplication.shared.connectedScenes.first
                if let sd: SceneDelegate = (scene?.delegate as? SceneDelegate){
                    sd.configureInitialviewControlr()
                }
            }
        }
        
    }
}
