//
//  BarButtonItem.swift
//  chatApp
//
//  Created by apple on 11.09.2023.
//

import UIKit

extension UIBarButtonItem {
    func setCustomSize(width: CGFloat, height: CGFloat) {
        let imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: width - (self.image?.size.width ?? 0.0) )
        self.imageInsets = imageInsets
    }
}


