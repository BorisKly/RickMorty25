//
//  CharactersListView.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import UIKit
import SnapKit

class CharactersTableViewCell: UITableViewCell {

    static let identifier = "CharactersTableViewCell"

    private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "photo")
        return imageView
    }()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = Fonts.customHuge
        label.textColor = .txtColor
        return label
    }()

    var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "status"
        label.font = Fonts.customSmall
        label.textColor = .txtColor
        return label
    }()

    var speciesLabel: UILabel = {
        let label = UILabel()
        label.text = "status"
        label.font = Fonts.customSmall
        label.textColor = .txtColor
        return label
    }()

    var statusIndicator = UIView()

    private let infoStack = UIStackView()
    private var statusStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .backColor
        contentView.addSubview(profileImageView)
        contentView.addSubview(infoStack)
        setupStatusIndicator()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with character: CharacterData) {
        nameLabel.text = character.name
        speciesLabel.text = character.species
        statusLabel.text = character.status

        if statusLabel.text?.lowercased() == "alive" {
            statusIndicator.backgroundColor = .successColor
        } else if statusLabel.text?.lowercased() == "dead" {
            statusIndicator.backgroundColor = .alertColor
        } else {
            statusIndicator.backgroundColor = .systemGray
        }
        loadImage(from: character.image ?? "") { [weak self] image in
            self?.profileImageView.image = image
        }
    }

    private func setupView() {
        infoStack.axis = .vertical
        infoStack.spacing = 8
        infoStack.alignment = .leading
        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(statusStack)

        statusStack.axis = .horizontal
        statusStack.spacing = 8
        statusStack.alignment = .center
        statusStack.addArrangedSubview(statusIndicator)
        statusStack.addArrangedSubview(statusLabel)
        statusStack.addArrangedSubview(speciesLabel)

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.lessThanOrEqualToSuperview().offset(-8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
            make.width.equalTo(profileImageView.snp.height)
        }
        infoStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-24)
        }
    }
    func setupStatusIndicator() {
        statusIndicator.translatesAutoresizingMaskIntoConstraints = false
        statusIndicator.layer.cornerRadius = 6
        statusIndicator.clipsToBounds = true
        statusIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(12)
        }
    }
}
