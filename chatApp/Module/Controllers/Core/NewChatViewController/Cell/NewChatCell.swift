//
//  NewChatCell.swift
//  chatApp
//
//  Created by apple on 11.09.2023.
//

import UIKit

class NewChatCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "NewChatCell"
    private var viewModel: UserViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            DispatchQueue.main.async {[weak self] in
                self?.username.text = viewModel.username
                self?.fullname.text = viewModel.fullname
                if let profileImageURL = viewModel.profileImageView {
                    FileUploader.getImage(withImageURL: profileImageURL ) { [weak self] image in
                        self?.profileImageView.image = image
                    }
                }
            }
        }
    }
    private let profileImageView = CustomImageView(image: #imageLiteral(resourceName: "Google_Contacts_logo copy"), width: 48, height: 48, cornerRedius: 48 / 2, background: .lightGray)
    private let username = CustomLabel(textLabel: "Username", fontLabel: .boldSystemFont(ofSize: 16))
    private let fullname = CustomLabel(textLabel: "Fullname", textColorLabel: .lightGray, numberOfLines: 2)
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    public func configure(user: User) {
        self.viewModel = UserViewModel(user: user)
    }
    private func configureUI() {
        backgroundColor = .clear
        selectionStyle = .none
        addConstraints()
        
    }
    private func addConstraints() {
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor)
        profileImageView.centerY(inView: self)
        
     
        let vStackView = UIStackView(arrangedSubviews: [
        username, fullname
        ])
        vStackView.axis = .vertical
        vStackView.spacing = 7
        vStackView.alignment = .leading
        addSubview(vStackView)
        vStackView.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, rightAnchor: rightAnchor, paddingLeft: 15, paddingRight: 15)
//        vStackView.anchor(right: rightAnchor, paddingTop: 10)
      
    }
}

