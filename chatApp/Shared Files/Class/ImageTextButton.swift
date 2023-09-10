//
//  ImageTextButton.swift
//  chatApp
//
//  Created by apple on 10.09.2023.
//

import UIKit

final class ImageTextButton: UIButton {
    lazy var buttonImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = .label.complementaryColor()
        return iv
    }()
    lazy var titlleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label.complementaryColor()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    init(imageName: String, title: String, bourderColor: UIColor? = nil, bourderWight: CGFloat? = nil) {
         super.init(frame: .zero)
        titlleLabel.text = title
        buttonImageView.image = UIImage(named: imageName)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonImageView)
        addSubview(titlleLabel)
        clipsToBounds = true
        layer.cornerRadius = 10
        backgroundColor = .label
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
    override func layoutSubviews() {
        super.layoutSubviews()
        titlleLabel.sizeToFit()
        let buttonImageViewSize: CGFloat = 18
        let buttonImageX: CGFloat = (frame.size.width - titlleLabel.frame.size.width - buttonImageViewSize - 5) / 2
        buttonImageView.frame = CGRect(x: buttonImageX, y: (frame.size.height - titlleLabel.frame.size.height + 5) / 2, width: buttonImageViewSize, height: buttonImageViewSize)
        titlleLabel.frame = CGRect(x: buttonImageX + buttonImageViewSize + 5, y: (frame.size.height - buttonImageViewSize) / 2 , width: titlleLabel.frame.size.width, height: titlleLabel.frame.size.height)
    }
}
