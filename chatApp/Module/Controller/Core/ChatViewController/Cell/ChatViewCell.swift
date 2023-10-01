//
//  ChatViewCell.swift
//  chatApp
//
//  Created by apple on 11.09.2023.
//

import UIKit
import SDWebImage

protocol ChatCellDelegate: AnyObject {
    func cell(wantToPlayVideo cell: ChatCell, videoURL: URL?)
    func cell(wantToPlayAudio cell: ChatCell, audioURL: URL?, isPlay: Bool)
    func cell(wantToShowImage cell: ChatCell, imageURL: URL?)
    func cell(wantToShowLocation cell: ChatCell, locationURL: URL?)
}

class ChatCell: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: ChatCellDelegate?
    
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
    private lazy var  postImage: CustomImageView = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImage))
        let iv = CustomImageView()
        iv.isHidden = true
        
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    private lazy var postVideo: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        button.setTitle(" Play video", for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePlayVideo), for: .touchUpInside)
        return button
    }()
    private lazy var postAudio: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.setTitle(" Play Audio", for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(hendelplayAudio), for: .touchUpInside)
        return button
    }()
    private lazy var postLocation: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.circle"), for: .normal)
        button.setTitle(" Google Maps", for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handleLocationButton), for: .touchUpInside)
        return button
    }()
    var isVoiceIsPlaying: Bool = true
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    func resetAudioSettings() {
        postAudio.setTitle(" Play Audio", for: .normal)
        postAudio.setImage(UIImage(systemName: "play.fill"), for: .normal)
        isVoiceIsPlaying = true
    }
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
        
        addSubview(postImage)
        postImage.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        addSubview(postVideo)
        postVideo.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        
        addSubview(postAudio)
        postAudio.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        addSubview(postLocation)
        postLocation.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
        
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
        
        postImage.sd_setImage(with: viewModel.imageURL)
        textView.isHidden = viewModel.isTextHide
        postImage.isHidden = viewModel.isImageHide
        postVideo.isHidden = viewModel.isVideoHide
        postAudio.isHidden = viewModel.isAudioHide
        postLocation.isHidden = viewModel.isLocationHide
        if !viewModel.isImageHide {
            postImage.setHeight(200 )
            bubbleContainer.backgroundColor = .clear
        }
    }
    
    @objc private func handlePlayVideo() {
        guard let viewModel = viewModel else {return}
        delegate?.cell(wantToPlayVideo: self, videoURL: viewModel.videoURL)
    }
    @objc private func hendelplayAudio() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(wantToPlayAudio: self, audioURL: viewModel.audioURL, isPlay: isVoiceIsPlaying)
        isVoiceIsPlaying.toggle()
        postAudio.setTitle(isVoiceIsPlaying ? " Play Audio" : " Stop Audio", for: .normal)
        postAudio.setImage(UIImage(systemName: isVoiceIsPlaying ? "play.fill" : "stop.fill"), for: .normal)
    }
    @objc private func handleLocationButton() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(wantToShowLocation: self, locationURL: viewModel.locationURL)
    }
    @objc private func handleImage() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(wantToShowImage: self, imageURL: viewModel.imageURL)
    }
}
