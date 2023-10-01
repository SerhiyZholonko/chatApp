//
//  ProfileView.swift
//  chatApp
//
//  Created by apple on 28.09.2023.
//

import UIKit

class ProfileViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "ProfileViewCell"
    var viewModel: ProfileViewModel? {
        didSet {
            configure()
        }
    }
    private let titleLabel = CustomLabel(textLabel: "Name", textColorLabel: .systemGreen)
    private let userLabel = CustomLabel(textLabel: "Oprah")
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Functions
    private func configureUI() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, userLabel])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 20)
    }
    private func configure() {
        guard let viewModel = viewModel else { return }
        DispatchQueue.main.async {[ self ] in
            titleLabel.text = viewModel.fieldTitle
            userLabel.text = viewModel.optionalType
        }
    }
}


