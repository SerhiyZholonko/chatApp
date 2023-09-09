//
//  RegisterViewController.swift
//  chatApp
//
//  Created by apple on 08.09.2023.
//

import UIKit


class RegisterViewController: UIViewController {
    //MARK: - Properties
    var viewModel = RegisterViewModel()
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setAttributedTitle(regularText: "Already Have An Account? ", boldText: "Sign in",fontSize: 16)
        button.setHeight(50)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccountButton), for: .touchUpInside)
        return button
    }()
    private lazy var avatarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lightGray
        button.setDimensions(height: 150, width: 150)
        button.layer.cornerRadius = 75
        button.addTarget(self, action: #selector(handleAvatarButton), for: .touchUpInside)
        return button
    }()
    private let emailTF: CustomTextField = .init(placeholder: "Email", keyboardType: .emailAddress)
    private let passwordTF: CustomTextField = .init(placeholder: "Password", isSecureText: true)
    private let fullnameTF: CustomTextField = .init(placeholder: "Fullname")
    private let usernameTF: CustomTextField = .init(placeholder: "Username")
    
    private lazy var signUpButton = AuthButton(viewModel: viewModel, title: "Sign Up")
    //MARK: - Lilecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureForTextFeild()
        configureButton()
    }
    //MARK: - Functions
    private func configureUI() {
        view.backgroundColor = .systemBackground
        addConstraints()
    }
    private func configureForTextFeild(){
        emailTF.addTarget(self, action: #selector (handleTextChanged (sender:)) , for:
                .editingChanged)
        passwordTF.addTarget(self, action: #selector (handleTextChanged (sender:)), for:
                .editingChanged)
        fullnameTF.addTarget(self, action: #selector (handleTextChanged (sender:)) , for:
                .editingChanged)
        usernameTF.addTarget(self, action: #selector (handleTextChanged (sender:)), for:
                .editingChanged)
    }
    private func addConstraints() {
        
        view.addSubview(avatarButton)
        avatarButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        avatarButton.centerX(inView: view)
        
        let stackView = UIStackView(arrangedSubviews: [
            emailTF,
            passwordTF,
            fullnameTF,
            usernameTF,
            signUpButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.anchor(top: avatarButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 20, paddingRight: 20)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        alreadyHaveAccountButton.centerX(inView: view)
    }
    private func configureButton() {
        signUpButton.delegate = self
    }
    //MARK: - OBJC
    @objc private func handleAlreadyHaveAccountButton() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func handleAvatarButton() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc private func handleTextChanged(sender: UITextField) {
        if let text = sender.text {
            switch sender {
            case emailTF:
                viewModel.email = text
            case passwordTF:
                viewModel.password = text
            case fullnameTF:
                viewModel.fullname = text
            case usernameTF:
                viewModel.username = text
            default:
                break
            }
            updateForm()
        }
        
    }
    private func updateForm() {
        signUpButton.isEnabled = viewModel.formIsFaild
        signUpButton.backgroundColor = viewModel.backgroundColor
        signUpButton.setTitleColor(viewModel.titleColor, for:.normal)
    }
}



//MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            avatarButton.setBackgroundImage(editedImage, for: .normal)
            avatarButton.contentMode = .scaleAspectFill
            avatarButton.layer.cornerRadius = avatarButton.bounds.width / 2.0
            avatarButton.clipsToBounds = true
            avatarButton.layer.borderColor = UIColor.label.cgColor
            avatarButton.layer.borderWidth = 2
            avatarButton.setImage(nil, for: .normal)
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - AuthButtonDelegate

extension RegisterViewController: AuthButtonDelegate {
    func handleLoginVC() {
        guard let email = emailTF.text?.lowercased(),
              let password = passwordTF.text,
              let fullname = fullnameTF.text,
              let username = usernameTF.text?.lowercased(),
              let image = avatarButton.backgroundImage(for: .normal) else { return }
        
        let creadtional = AuthCreadtion(email: email, password: password, username: username, fullname: fullname, profileImage: image)
        AuthService.registerUser(creadtional: creadtional) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
    
    
}


