//
//  CustomImageView.swift
//  chatApp
//
//  Created by apple on 09.09.2023.
//

import UIKit


class CustomImageView: UIImageView {
    
    //MARK: - Inut
    init(image: UIImage? = nil, width: CGFloat? = nil, height: CGFloat? = nil, cornerRedius: CGFloat? = nil, contentMode: ContentMode = .scaleAspectFit, background: UIColor? = nil, tintColor: UIColor? = nil ) {
        super.init(frame: .zero)
        self.image = image
        if let cornerRedius = cornerRedius {
            layer.cornerRadius = cornerRedius
            self.contentMode = contentMode
            self.clipsToBounds = true
        }
        if let width = width {
            setWidth(width)
        }
        if let tintColor = tintColor {
            self.tintColor = tintColor
        }
        if let height = height {
            setHeight(height)
        }
        if let background = background {
            self.backgroundColor = background
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
