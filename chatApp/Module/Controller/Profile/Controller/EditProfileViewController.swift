//
//  EditProfileViewController.swift
//  chatApp
//
//  Created by apple on 30.09.2023.
//

import UIKit
import SDWebImage

class EditProfileViewController: UIViewController, UIAnimatable{
    //MARK: - Properties
    private let user: User
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.setDimensions(height: 50, width: 200)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSubmitButton), for: .touchUpInside)
        return button
    }()
    private var selectImage: UIImage?
    private let profileImageView = CustomImageView(width: 125, height: 125,cornerRedius: 125 / 2, background: .lightGray)
    private let fullnameLbl = CustomLabel(textLabel: "Fullname", textColorLabel: .systemGreen, alignmentLabel: .left)
    private let fulnameTxf = CustomTextField(placeholder: "Fullname")
    
    private let usernameLbl = CustomLabel(textLabel: "Username", textColorLabel: .systemGreen, alignmentLabel: .left)
    private let usernameTxf = CustomTextField(placeholder: "Username")
    
    private lazy var imagePicker: UIImagePickerController = {
       let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        return imagePicker
    }()
    
     //MARK: - Init
     init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureProfileData()
    }
    //MARK: - Functions
    private func configureUI() {
        view.backgroundColor = .systemBackground
        title = "Edit Profile"
        
        view.addSubview(submitButton)
        submitButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor, paddingRight: 12)
        view.addSubview(profileImageView)
        profileImageView.centerX(inView: view)
        profileImageView.anchor(top: submitButton.bottomAnchor, paddingTop: 20)
        
        let stackView = UIStackView(arrangedSubviews: [
        fullnameLbl, fulnameTxf, usernameLbl, usernameTxf
        ])
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        view.addSubview(stackView)
        
        stackView.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 30, paddingRight: 30)
        configureTapGesture()
    }
    private func configureProfileData() {
        DispatchQueue.main.async { [self] in
            fulnameTxf.text = user.fullname
            usernameTxf.text = user.username
            profileImageView.sd_setImage(with: URL(string: user.profileImageURL))
        }
    }
    private func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageView))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
    }
    @objc private func handleSubmitButton() {
        guard let fullname = fulnameTxf.text else { return }
        guard let username = usernameTxf.text else { return  }
        showLoadingAnimation()
        if selectImage == nil {
            let params = [
                "fullname": fullname,
                "username": username
            ]
           updateUser(params: params)
        } else  {
            guard let selectImage = selectImage else { return }
            FileUploader.uploadImage(image: selectImage) {[self] imageURL in
                let params = [
                    "fullname": fullname,
                    "username": username,
                    "profileImageURL": imageURL
                ]
                updateUser(params: params)
            }
        }
    }
    private func updateUser(params: [String: Any]) {
        UserServiece.setUserData(data: params) { [self] _ in
            hideLoadingAnimation()
            NotificationCenter.default.post(name: .userProfile, object: nil)
            usernameTxf.resignFirstResponder()
            fulnameTxf.resignFirstResponder()
            navigationController?.popViewController(animated: true)
        }
    }
    @objc private func handleProfileImageView() {
        self.present(imagePicker, animated: true)
    }
}


 //MARK: - image piker delegate
extension EditProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        self.selectImage = image
        self.profileImageView.image = image
        
        dismiss(animated: true)
    }
}
