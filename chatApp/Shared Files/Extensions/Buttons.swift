//
//  Buttons.swift
//  chatApp
//
//  Created by apple on 08.09.2023.
//

import UIKit


extension UIButton {
    func setAttributedTitle(regularText: String, boldText: String, fontSize: CGFloat = 17, regularColor: UIColor = .label.withAlphaComponent(0.7), boldColor: UIColor = .label) {
        let attributedText = NSMutableAttributedString(string: regularText, attributes: [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: regularColor
        ])
        
        let boldTextAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: fontSize),
            .foregroundColor: boldColor
        ]
        
        let boldPart = NSAttributedString(string: boldText, attributes: boldTextAttributes)
        
        attributedText.append(boldPart)
        
        self.setAttributedTitle(attributedText, for: .normal)
    }
}
