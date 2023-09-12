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
    private func addConstraints() {
        addSubview(profileImageView)
        profileImageView.anchor(left: leftAnchor)
        profileImageView.centerY(inView: self)
        
        addSubview(dateLabel)
        dateLabel.anchor(right: rightAnchor, paddingRight: 15, width: 100)
        dateLabel.centerY(inView: self)
        let vStackView = UIStackView(arrangedSubviews: [
        fullname, recentMessage
        ])
        vStackView.axis = .vertical
        vStackView.spacing = 7
        vStackView.alignment = .leading
        addSubview(vStackView)
        vStackView.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, rightAnchor: dateLabel.leftAnchor, paddingLeft: 15, paddingRight: 15)
        vStackView.anchor(right: dateLabel.rightAnchor, paddingTop: 10)
      
    }
}


