//
//  ChatViewController.swift
//  chatApp
//
//  Created by apple on 11.09.2023.
//

import UIKit
import SDWebImage
import ImageSlideshow
import SwiftAudioPlayer

class ChatViewController: UICollectionViewController {
    //MARK: - Properties
    var messages: [[Message]] = [] {
        didSet {
            emptyView.isHidden = !messages.isEmpty
        }
    }
    var otherUser: User
    var currentUser: User
    private lazy var customInputView: CustomeInputView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let iv = CustomeInputView(frame: frame)
        iv.delegate = self
        return iv
    }()
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 12
        view.isHidden = true
        return view
    }()
    private let emptyLabel = CustomLabel(textLabel: "There are no conversation is empty", textColorLabel: .systemYellow, numberOfLines: 2)
    private lazy var attachAlert: UIAlertController = {
        let alert = UIAlertController(title: "Attach File", message: "Select the button you want to attach", preferredStyle: .actionSheet)
        alert.addAction (UIAlertAction(title: "Camera", style: .default, handler: {[weak self] _ in
            self?.handleCamera()
        }))
        alert.addAction (UIAlertAction(title: "Gallery", style: .default, handler: {[weak self] _ in
            self?.handleGallery()
        }))
        alert.addAction (UIAlertAction(title: "Location", style: .default, handler: {[weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.present(strongSelf.locationAlert, animated: true)
        }))
        return alert
    }()
    private lazy var locationAlert: UIAlertController = {
        let alert = UIAlertController(title: "Share location", message: "Select the button you want to share location from", preferredStyle: .actionSheet)
        alert.addAction (UIAlertAction(title: "Current Location", style: .default, handler: {[weak self] _ in
            self?.handleCurrentLocation()
        }))
        alert.addAction (UIAlertAction(title: "Google Map", style: .default, handler: {[weak self] _ in
//            self?.handleGoogleMap()
        }))
        alert.addAction (UIAlertAction(title: "Cansel", style: .cancel))
        return alert
    }()
    lazy var imagePiker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        return picker
    }()
    //MARK: - Init
    init(otherUser: User, currentUser: User) {
        self.otherUser = otherUser
        self.currentUser = currentUser
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        fetchMessages()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.markReadAllMessge()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        markReadAllMessge()
    }
    override var inputAccessoryView: UIView? {
        return customInputView
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    //MARK: - Functions
    private func configureUI() {
        collectionView.backgroundColor = .systemBackground
        customInputView.isUserInteractionEnabled = true
        navigationItem.title = otherUser.fullname.capitalized
        addConstraints()
        configureTapGesture()
        
        view.addSubview(emptyView)
        emptyView.anchor( left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 25, paddingBottom: 60, paddingRight: 25, height: 60)
        emptyView.addSubview(emptyLabel)
        emptyLabel.center(inView: emptyView)
        emptyLabel.anchor(left: emptyView.leftAnchor, right: emptyView.rightAnchor, paddingLeft: 5, paddingRight: 5)
    }
    private func fetchMessages() {
        MessageService.fetchMessages(otherUser: otherUser) { messages in
            //            self.messages = messages
            let groupMessages = Dictionary(grouping: messages) { element -> String in
                let dateValue = element.timestamp.dateValue()
                let stringDateValue = self.stringValue (forDate: dateValue)
                return stringDateValue ?? ""
            }
            self.messages.removeAll()
            
            let sortedKeys = groupMessages.keys.sorted(by: {$0 < $1})
            sortedKeys.forEach { key in
                let values = groupMessages[key]
                self.messages.append(values ?? [])
            }
            self.collectionView.reloadData()
            self.collectionView.scrollToLastItem()
        }
    }
    private func configureCollectionView() {
        let inset: CGFloat = 40 // Adjust the inset value as needed
        collectionView.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: 0, right: 0)
        
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        collectionView.register(ChatHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ChatHeader.identifier)
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
    }
   
    private func addConstraints() {
        view.addSubview(customInputView)
        customInputView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        customInputView.addGestureRecognizer(tapGesture)
    }
    private func  markReadAllMessge() {
        MessageService.markReadAllMessage(otherUser: otherUser)
    }
    @objc private func handleTap() {
        // Handle the tap action here
        // You can leave this empty or perform some custom action if needed
    }
}

extension ChatViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages[section].count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
        cell.delegate = self
        let message = messages[indexPath.section][indexPath.item]
        cell.viewModel = MessageViewModel(message: message)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 40, left: 0, bottom: 15, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cell = ChatCell(frame: frame)
        let message = messages[indexPath.section][indexPath.item]
        cell.viewModel = MessageViewModel(message: message)
        cell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimeteSize = cell.systemLayoutSizeFitting(targetSize)
        
        return CGSize(width: view.frame.width, height: estimeteSize.height)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let firstMessage = messages[indexPath.section].first else { return UICollectionReusableView() }
            let dateValue = firstMessage.timestamp.dateValue()
            let stringValue = stringValue(forDate: dateValue)
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ChatHeader.identifier, for: indexPath) as! ChatHeader
            cell.dateValue = stringValue
            return cell
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}

//MARK: - CustomeInputViewDelegate

extension ChatViewController: CustomeInputViewDelegate {
    func inputViewForAudio(_ view: CustomeInputView, audioURL: URL) {
        showLoadingAnimation()
        FileUploader.uploudeAudio(audionUrl: audioURL) { [self] audionString in
            MessageService.fetchSingleResentMessage(otherUser: otherUser) { [self] unreadMessage in
                MessageService.uploadMessage(audioUrl: audionString, currentUser: currentUser, unReadCounter: unreadMessage + 1, otherUser: otherUser) { [self] error in
                    hideLoadingAnimation()
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                }
            }
        }
    }
    
    func custonViewForAttach(_ view: CustomeInputView) {
        present(attachAlert, animated: true)
    }
    func inputView(_ view: CustomeInputView, wantUploadMessage message: String) {
        MessageService.fetchSingleResentMessage(otherUser: otherUser) { [self] unReadMessage in
            MessageService.uploadMessage(message: message, currentUser: currentUser, unReadCounter: unReadMessage + 1, otherUser: otherUser) { [self] _ in
                collectionView.reloadData()
            }
        }
        customInputView.clearTextView()
    }
}


 //MARK: - ChatCellDelegate

extension ChatViewController: ChatCellDelegate {
  
    func cell(wantToShowImage cell: ChatCell, imageURL: URL?) {
        let imageSlideShow = ImageSlideshow()
        guard let imageURL = imageURL else { return }
        SDWebImageManager.shared.loadImage(with: imageURL, progress: nil)  { image,_,_,_,_,_ in
            guard let image = image else { return }
            imageSlideShow.setImageInputs([
            ImageSource(image: image)
            ])
            imageSlideShow.delegate = self
            let controller = imageSlideShow.presentFullScreenController(from: self)
            controller.slideshow.activityIndicator = DefaultActivityIndicator()
        }

    }
    
    func cell(wantToPlayVideo cell: ChatCell, videoURL: URL?) {
        guard let videoURL = videoURL else { return }
        let playerVC = VideoPlayerViewController(videoURL: videoURL)
        navigationController?.pushViewController(playerVC, animated: true)
    }
    func cell(wantToPlayAudio cell: ChatCell, audioURL: URL?, isPlay: Bool) {
        if isPlay {
            guard let audioURL = audioURL else { return }
            SAPlayer.shared.startRemoteAudio(withRemoteUrl: audioURL)
            SAPlayer.shared.play()
            let _ = SAPlayer.Updates.PlayingStatus.subscribe { playingStatus in
                if playingStatus == .ended {
                    cell.resetAudioSettings() 
                }
            }
        } else {
            SAPlayer.shared.stopStreamingRemoteAudio()
        }
      
    }
    func cell(wantToShowLocation cell: ChatCell, locationURL: URL?) {
        guard let googleURLApp = URL(string: "comgooglemaps://") else { return }
        guard let locationURL = locationURL else { return }
        if UIApplication.shared.canOpenURL(googleURLApp) {
            UIApplication.shared.open(locationURL)
        } else {
            UIApplication.shared.open(locationURL, options: [:])
        }
    }
   
}

 //MARK: -

extension ChatViewController: ImageSlideshowDelegate {
    
}
