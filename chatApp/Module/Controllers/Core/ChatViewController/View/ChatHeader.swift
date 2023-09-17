//
//  ChatHeader.swift
//  chatApp
//
//  Created by apple on 17.09.2023.
//

import UIKit


class ChatHeader: UICollectionReusableView{
     //MARK: - Properties
    static let identifier = "ChatHeader"
    var dateValue: String? {
        didSet {
            configure()
        }
    }
    private let dateLabel: CustomLabel = {
        let label = CustomLabel(textLabel: "10/10/2010", textColorLabel: .white, fontLabel: .boldSystemFont(ofSize: 16))
        label.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent (0.5)
        label.setDimensions (height: 30, width: 100)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        return label
    }()
     //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dateLabel)
        dateLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     //MARK: - functions
    private func configure() {
        guard let dateValue = dateValue else { return }
        DispatchQueue.main.async {[weak self] in
            self?.dateLabel.text = dateValue
        }
    }
}
