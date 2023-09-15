//
//  CustomeInputView.swift
//  chatApp
//
//  Created by apple on 12.09.2023.
//

import UIKit

protocol CustomeInputViewDelegate: AnyObject {
    func inputView(_ view: CustomeInputView, wantUploadMessage message: String)
}

class CustomeInputView: UIView {
    //MARK: - Properties
    weak var delegate: CustomeInputViewDelegate?
    let inputTextView = InputTextView()
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    private lazy var postBackgroundColor: CustomImageView = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hanelePostButton))
        let iv = CustomImageView(width: 40, height: 40, cornerRedius: 20, background: .systemGreen)
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    private lazy var postButton: UIButton = {
        let button = UIButton (type: .system)
        button.setBackgroundImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .white
        button.setDimensions (height: 28, width: 28)
        button.addTarget(self, action: #selector(hanelePostButton), for: .touchUpInside)
        return button
    }()
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [inputTextView, postBackgroundColor])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        sv.distribution = .fillProportionally
        return sv
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
        backgroundColor = .systemBackground
        autoresizingMask = .flexibleHeight
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: 5, paddingRight: 5)
        addSubview (postButton)
        postButton.center(inView: postBackgroundColor)
        inputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postBackgroundColor.leftAnchor , paddingTop: 12, paddingLeft: 8, paddingBottom: 5, paddingRight: 8)
        addSubview(dividerView)
        dividerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
    }
    @objc func hanelePostButton() {
        guard !inputTextView.text.isEmpty else { return }
        delegate?.inputView(self, wantUploadMessage: inputTextView.text)
    }
    func clearTextView() {
        inputTextView.text = ""
        inputTextView.placeHolderLabel.isHidden = false
    }
    override var intrinsicContentSize: CGSize {
        return .zero
    }
}
