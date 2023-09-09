//
//  UIColor.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//

import UIKit

extension UIColor {
    func complementaryColor() -> UIColor {
        guard let components = self.cgColor.components else {
            // The color cannot be decomposed into its components
            return UIColor.black // Return a default color
        }
        
        let red = 1.0 - components[0]
        let green = 1.0 - components[1]
        let blue = 1.0 - components[2]
        let alpha = components[3]
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
