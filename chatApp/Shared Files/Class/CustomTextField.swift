//
//  CustomTextField.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//

import UIKit

class CustomTextField: UITextField {
    //MARK: - Properties
    
    //MARK: - Init
    init(placeholder: String, keyboardType: UIKeyboardType = .default, isSecureText: Bool = false, bourderColor: UIColor? = nil, bourderWight: CGFloat? = nil) {
        super.init(frame: .zero)
        borderStyle = .none
        textColor = .label
        keyboardAppearance = .light
        clearButtonMode = .whileEditing
        backgroundColor = .secondarySystemBackground
        setHeight(50)
        let letfSpacer = UIView()
        letfSpacer.setDimensions(height: 50, width: 12)
        leftViewMode = .always
        self.leftView = letfSpacer
        layer.cornerRadius = 6
        
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecureText
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
}
