//
//  ChatViewController.swift
//  chatApp
//
//  Created by apple on 11.09.2023.
//

import UIKit

class ChatViewController: UICollectionViewController {
    //MARK: - Properties
     var messages: [Message] = []
    private var otherUser: User
    private var currentUser: User
    private lazy var customInputView: CustomeInputView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let iv = CustomeInputView(frame: frame)
        iv.delegate = self
        return iv
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

    }
    private func fetchMessages() {
        MessageService.fetchMessages(otherUser: otherUser) { messages in
            self.messages = messages
            print("Debag: ",messages)
            self.collectionView.reloadData()
        }
    }
    private func configureCollectionView() {
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        
    }
    private func addConstraints() {
        view.addSubview(customInputView)
        customInputView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    private func configureTapGesture() {
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
          customInputView.addGestureRecognizer(tapGesture)
      }

      @objc private func handleTap() {
          // Handle the tap action here
          // You can leave this empty or perform some custom action if needed
      }
    
}


extension ChatViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCell.identifier, for: indexPath) as! ChatCell
        let message = messages[indexPath.item]
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
        let message = messages[indexPath.item]
        cell.viewModel = MessageViewModel(message: message)
        cell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimeteSize = cell.systemLayoutSizeFitting(targetSize)
        
        return CGSize(width: view.frame.width, height: estimeteSize.height)
    }
}


//MARK: -

extension ChatViewController: CustomeInputViewDelegate {
    func inputView(_ view: CustomeInputView, wantUploadMessage message: String) {
        
        MessageService.uploadMessage(message: message, currentUser: currentUser, otherUser: otherUser) { error in
            
        }
        
        customInputView.clearTextView()
        collectionView.reloadData() 
    }
    
    
}
