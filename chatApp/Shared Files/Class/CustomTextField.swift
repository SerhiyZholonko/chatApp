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
    init(placeholder: String, keyboardType: UIKeyboardType = .default, isSecureText: Bool = false) {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
}
