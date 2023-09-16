//
//  ConversationCell.swift
//  chatApp
//
//  Created by apple on 11.09.2023.
//

import UIKit

class ConversationCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "ConversationCell"
    private let unReadMsgLabel: UILabel = {
        let label = UILabel ()
        label.text = "7"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.setDimensions(height: 30, width: 30)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        return label
    }()
    var viewModel: MessageViewModel? {
        didSet{
            configure()
        }
    }
    private let profileImageView = CustomImageView(image: #imageLiteral(resourceName: "Google_Contacts_logo copy"), width: 60, height: 60, cornerRedius: 30, background: .lightGray)
    private let fullname = CustomLabel(textLabel: "Fullname", fontLabel: .boldSystemFont(ofSize: 16))
    private let recentMessage = CustomLabel(textLabel: "recent message recent message recent", textColorLabel: .lightGray, numberOfLines: 2)
    private let dateLabel = CustomLabel(textLabel: "23/12/2011",textColorLabel: .lightGray)
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func configureUI() {
        backgroundColor = .clear
        selectionStyle = .none
        addConstraints()
        
    }
    private func configure() {
        guard let viewModel = viewModel else { return }
        DispatchQueue.main.async { [weak self] in
            self?.profileImageView.sd_setImage(with: viewModel.profileImageURL)
            self?.fullname.text = viewModel.fullName
            self?.recentMessage.text = viewModel.messageText
            self?.dateLabel.text = viewModel.timestampString
            self?.unReadMsgLabel.text = "\(viewModel.unReadCount)"
            self?.unReadMsgLabel.isHidden = viewModel.showIdHideUnreadLabel
        }
       
    }
    private func addConstraints() {
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor)
        profileImageView.centerY(inView: self)
        
        let dateCounterStack = UIStackView(arrangedSubviews: [
        dateLabel, unReadMsgLabel
        ])
        dateCounterStack.axis = .vertical
        dateCounterStack.spacing = 7
        dateCounterStack.alignment = .trailing
         addSubview(dateCounterStack)
        dateCounterStack.centerY(inView: profileImageView, rightAnchor: rightAnchor, paddingRight: 15)
        let nameMessageStack = UIStackView(arrangedSubviews: [
        fullname, recentMessage
        ])
        nameMessageStack.axis = .vertical
        nameMessageStack.spacing = 7
        nameMessageStack.alignment = .leading
        addSubview(nameMessageStack)
        nameMessageStack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, rightAnchor: dateCounterStack.leftAnchor, paddingLeft: 15, paddingRight: 15)
      
    }
}


