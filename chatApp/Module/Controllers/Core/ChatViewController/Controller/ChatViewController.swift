//
//  ChatViewController.swift
//  chatApp
//
//  Created by apple on 11.09.2023.
//

import UIKit

class ChatViewController: UICollectionViewController {
    //MARK: - Properties
     var messages: [[Message]] = []
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


//MARK: -

extension ChatViewController: CustomeInputViewDelegate {
    func inputView(_ view: CustomeInputView, wantUploadMessage message: String) {
        MessageService.fetchSingleResentMessage(otherUser: otherUser) { [self] unReadMessage in
            MessageService.uploadMessage(message: message, currentUser: currentUser, unReadCounter: unReadMessage + 1, otherUser: otherUser) { [self] _ in
                collectionView.reloadData()
            }
        }
      
        customInputView.clearTextView()

       
    }
    
    
}
