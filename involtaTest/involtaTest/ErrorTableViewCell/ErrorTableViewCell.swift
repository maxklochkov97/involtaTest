//
//  ErrorTableViewCell.swift
//  involtaTest
//
//  Created by Максим Клочков on 07.05.2022.
//

import UIKit

class ErrorTableViewCell: UITableViewCell {

    weak var tapTryAgainDelegate: TapTryAgainDelegate?

    private let errorTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.text = "Server is temporarily unavailable.\nTry downloading the data later."
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let spinnerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "spinner"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let tryAgainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try again", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(tryAgainAction), for: .touchUpInside)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func tryAgainAction() {
        print(#function)
        tapTryAgainDelegate?.loadMessageFromServer()
    }

    private func setupView() {
        self.contentView.backgroundColor = .lightGray
        spinnerImageView.rotate(duration: 3)
    }

    private func layout() {
        [errorTextLabel, tryAgainButton].forEach { contentView.addSubview($0) }

        let offset: CGFloat = 16

        NSLayoutConstraint.activate([
//            spinnerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
//            spinnerImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            spinnerImageView.widthAnchor.constraint(equalToConstant: 50),
//            spinnerImageView.heightAnchor.constraint(equalTo: spinnerImageView.widthAnchor, multiplier: 1),

            errorTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            errorTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            errorTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),

            tryAgainButton.topAnchor.constraint(equalTo: errorTextLabel.bottomAnchor, constant: offset),
            tryAgainButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: offset),
            tryAgainButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -offset),
            tryAgainButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -offset),
            tryAgainButton.heightAnchor.constraint(equalToConstant: 50),

        ])
    }
}
