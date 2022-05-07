//
//  MessageTableViewCell.swift
//  involtaTest
//
//  Created by Максим Клочков on 06.05.2022.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(_ model: String) {
        messageLabel.text = model
    }

    private func layout() {
        [messageLabel].forEach { contentView.addSubview($0) }

        let offset: CGFloat = 10

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset)
        ])
    }
}

