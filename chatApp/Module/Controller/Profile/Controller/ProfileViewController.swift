//
//  ProfileViewController.swift
//  chatApp
//
//  Created by apple on 27.09.2023.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    //MARK: - Properties
    private var user: User
    private let profileImageView = CustomImageView(cornerRedius: 20, background: .lightGray)
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.setDimensions(height: 50, width: 200)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
        return button
    }()
    private let tableView = UITableView()
     //MARK: - init
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
        configureUITableView()
        configureData()
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserProfile), name: .userProfile, object: nil)
    }
    //MARK: - Functions
    private func configureUI() {
        title = "My Profile"
        view.backgroundColor = .systemBackground
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 30)
        profileImageView.centerX(inView: view)
        profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 1).isActive = true
        
        view.addSubview(tableView)
        tableView.anchor(top: profileImageView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 25, paddingRight: 20)
        
        view.addSubview(editButton)
        editButton.centerX(inView: view)
        editButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20)
    }
    private func configureUITableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileViewCell.self, forCellReuseIdentifier: ProfileViewCell.identifier)
        tableView.rowHeight = 70
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
    }
    private func configureData() {
        tableView.reloadData()
        guard let imageURL = URL(string: user.profileImageURL) else { return }
        profileImageView.sd_setImage(with: imageURL )
    }
    @objc func handleEditButton() {
        let vc = EditProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func handleUserProfile() {
        print("Debug: Observe")
        UserServiece.fetchUser(uid: user.uid) { [self] currentUser in
            user = currentUser
            configureData()

        }
    }
}


 //MARK: -
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileField.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileViewCell.identifier, for: indexPath) as! ProfileViewCell
        guard let field = ProfileField(rawValue: indexPath.row) else { return cell }
        cell.viewModel = ProfileViewModel(user: user, field: field)
        return cell
    }
    
    
}
