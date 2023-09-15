//
//  ChatViewCell.swift
//  chatApp
//
//  Created by apple on 11.09.2023.
//

import UIKit
import SDWebImage

class ChatCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "ChatViewCell"
    
    var viewModel: MessageViewModel? {
        didSet {
            configure()
        }
    }
    
    var bubbleRightAnchor: NSLayoutConstraint!
    var bubbleLeftAnchor: NSLayoutConstraint!
    var dateRightAnchor: NSLayoutConstraint!
    var dateLeftAnchor: NSLayoutConstraint!

    
    private let profileImageView = CustomImageView( width: 30, height: 30, cornerRedius: 15, background: .systemGray)
    private let dateLabel = CustomLabel(textLabel: "10/10/2023", textColorLabel: .lightGray)
    
    private let bubbleContainer : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9058823529, green: 0.9098039216, blue: 0.9137254902, alpha: 1)
        view.layer.cornerRadius = 12
        return view
    }()
    private let textView: UITextView = {
        let tf = UITextView()
        tf.backgroundColor = .clear
        tf.isEditable = false
        tf.isScrollEnabled = false
        tf.text = "some text. some text"
        tf.font = .systemFont(ofSize: 16)
        return tf
    }()
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func configureUI() {
        addSubview (profileImageView)
        profileImageView.anchor (left: leftAnchor, bottom: bottomAnchor, paddingLeft: 10)
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor (top: topAnchor, bottom: bottomAnchor)
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant:250).isActive=true
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        bubbleLeftAnchor = bubbleContainer.leftAnchor.constraint (equalTo:
        profileImageView.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        bubbleRightAnchor = bubbleContainer.rightAnchor.constraint (equalTo: rightAnchor,
        constant: -12)
        bubbleRightAnchor.isActive = false
        addSubview(dateLabel)
        dateLeftAnchor = dateLabel.leftAnchor .constraint (equalTo: bubbleContainer.rightAnchor,
        constant: 12)
        dateLeftAnchor.isActive = false
        dateRightAnchor = dateLabel.rightAnchor.constraint (equalTo:
        bubbleContainer.leftAnchor, constant: -12)
        dateRightAnchor.isActive = false
        dateLabel.anchor(bottom: bottomAnchor)

    }
    private func configure() {
        guard let viewModel = viewModel else { return }
        bubbleContainer.backgroundColor = viewModel.messageBacgroungColor
        textView.text = viewModel.messageText
        textView.textColor = viewModel.messageColor
        
        bubbleRightAnchor.isActive = viewModel.rightAnchorActive
        dateRightAnchor.isActive = viewModel.rightAnchorActive
        
        bubbleLeftAnchor.isActive = viewModel.leftAnchorActive
        dateLeftAnchor.isActive = viewModel.leftAnchorActive
        
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        profileImageView.isHidden = viewModel.shouldshowHideProfileImage
        guard let timestampString = viewModel.timestampString else { return }
        dateLabel.text = timestampString
    }

}
