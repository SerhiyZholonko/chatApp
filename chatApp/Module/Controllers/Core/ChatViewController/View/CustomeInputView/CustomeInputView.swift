//
//  CustomeInputView.swift
//  chatApp
//
//  Created by apple on 12.09.2023.
//

import UIKit


class CustomeInputView: UIView {
    //MARK: - Properties
    let inputTextView = InputTextView()
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
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
        addSubview(inputTextView)
        inputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 5, paddingRight: 8)
        addSubview(dividerView)
        dividerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
    }
    override var intrinsicContentSize: CGSize {
        return .zero
    }
}
