//
//  AuthButton.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//

import UIKit

protocol AuthButtonDelegate: AnyObject {
    func handleLoginVC()
}

class AuthButton: UIButton {
    
    //MARK: - Properties
    weak var delegate: AuthButtonDelegate?
    //MARK: - Init
    init(viewModel: AuthViewModelProtocol, title: String, bourderColor: UIColor? = nil, bourderWight: CGFloat? = nil) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 19)
        tintColor = .white
        backgroundColor = viewModel.backgroundColor
        setTitleColor(viewModel.titleColor, for: .normal)
        setHeight(50)
        layer.cornerRadius = 10
        addTarget(self, action: #selector(handleLoginVC), for: .touchUpInside)
        isEnabled = false
        if let bourderColor = bourderColor {
            layer.borderColor = bourderColor.cgColor
        }
        if let bourderWight = bourderWight {
            layer.borderWidth = bourderWight
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    @objc private func handleLoginVC() {
        delegate?.handleLoginVC()
    }
}


