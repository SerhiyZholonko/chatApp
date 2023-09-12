//
//  ChatViewController.swift
//  chatApp
//
//  Created by apple on 11.09.2023.
//

import UIKit

class ChatViewController: UICollectionViewController {
    //MARK: - Properties
    private var messages: [String] = [
        "Here's Sample data",
        "this the second line with more than one line",
        "Just wanna add more text for testing or where ever, and thats it for this lesson"
    ]
    private lazy var customInputView: CustomeInputView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let iv = CustomeInputView(frame: frame)
        return iv
    }()
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        
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
        addConstraints()
        configureTapGesture()

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
        cell.configure(text: message, isUserMessage: indexPath.item % 2 == 0) // Example logic to determine if it's a user message
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cell = ChatCell(frame: frame)
        let message = messages[indexPath.item]
        cell.configure(text: message, isUserMessage: indexPath.item % 2 == 0) // Example logic to determine if it's a user message
        cell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimeteSize = cell.systemLayoutSizeFitting(targetSize)
        
        return CGSize(width: view.frame.width, height: estimeteSize.height)
    }
}
