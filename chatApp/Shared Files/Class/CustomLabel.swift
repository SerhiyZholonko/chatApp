//
//  CustomLabel.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//

import UIKit


class CustomLabel: UILabel {
    //MARK: - Properties
    //MARK: - Init
    
    init(textLabel: String, textColorLabel: UIColor = .label,  fontLabel: UIFont = .systemFont(ofSize: 14), alignmentLabel: NSTextAlignment = .center, numberOfLines: Int? = nil) {
        super.init(frame: .zero)
        self.textAlignment = alignmentLabel
        self.text = textLabel
        self.font = fontLabel
        self.textColor = textColorLabel
        if let numberOfLines = numberOfLines {
            self.numberOfLines = numberOfLines
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
