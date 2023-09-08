//
//  RegisterViewController.swift
//  chatApp
//
//  Created by apple on 08.09.2023.
//

import UIKit


class RegisterViewController: UIViewController {
    //MARK: - Properties
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
    //MARK: - Lilecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Functions
    private func configureUI() {
        view.backgroundColor = .systemBackground
        addConstraints()
    }
    private func addConstraints() {
        
        view.addSubview(avatarButton)
        avatarButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20)
        avatarButton.centerX(inView: view)
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        alreadyHaveAccountButton.centerX(inView: view)
    }
    
    //MARK: - OBJC
    @objc private func handleAlreadyHaveAccountButton() {
        navigationController?.popViewController(animated: true)
    }
    @objc private func handleAvatarButton() {
        print("Change avatar")
    }
}
