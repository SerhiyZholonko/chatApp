//
//  NavigationBar.swift
//  chatApp
//
//  Created by apple on 11.09.2023.
//

import Foundation


import UIKit

extension UINavigationBar {
    func setTitleFont(_ font: UIFont, color: UIColor = .black) {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color
        ]
        
        self.titleTextAttributes = titleAttributes
    }
}


