//
//  CharacterView.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import UIKit
import SnapKit

class CharacterView: UIView {

    var profileImageView: UIImageView = {
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
        label.font = Fonts.customSuperHuge
        label.textColor = .txtColor
        return label
    }()

    var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "status"
        label.font = Fonts.customMedium
        label.textColor = .txtColor
        return label
    }()

    var genderLabel: UILabel = {
        let label = UILabel()
        label.text = "gender"
        label.font = Fonts.customMedium
        label.textColor = .txtColor
        return label
    }()

    var locationLabelText: UILabel = {
        let label = UILabel()
        label.text = "Last known location:"
        label.font = Fonts.customMedium
        label.textColor = .txtColor
        return label
    }()

    var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "location"
        label.font = Fonts.customSuperHuge
        label.textColor = .txtColor
        return label
    }()

    var episodeLabelText: UILabel = {
        let label = UILabel()
        label.text = "First seen in:"
        label.font = Fonts.customMedium
        label.textColor = .txtColor
        return label
    }()

    var episodeLabel: UILabel = {
        let label = UILabel()
        label.text = "No episode info"
        label.font = Fonts.customSuperHuge
        label.textColor = .txtColor
        return label
    }()

    private let fullStack = UIStackView()

    private let infoStack = UIStackView()
    private let locationStack = UIStackView()
    private let episodeStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundColor = .backColor
        self.addSubview(fullStack)
        setupStackView()
    }

    func setupStackView() {

        fullStack.axis = .vertical
        fullStack.spacing = 8
        fullStack.alignment = .center
        fullStack.distribution = .equalSpacing
        fullStack.addArrangedSubview(profileImageView)
        fullStack.addArrangedSubview(infoStack)
        fullStack.addArrangedSubview(locationStack)
        fullStack.addArrangedSubview(episodeStack)

        fullStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(128)
            make.bottom.equalToSuperview().inset(128)
            make.leading.trailing.equalToSuperview().inset(32)
        }

        setupAdditionalStackView()
    }

    func setupAdditionalStackView() {
        infoStack.axis = .vertical
        infoStack.spacing = 8
        infoStack.alignment = .leading
        infoStack.addArrangedSubview(nameLabel)
        infoStack.addArrangedSubview(statusLabel)
        infoStack.addArrangedSubview(genderLabel)

        locationStack.axis = .vertical
        locationStack.spacing = 8
        locationStack.alignment = .leading
        locationStack.addArrangedSubview(locationLabelText)
        locationStack.addArrangedSubview(locationLabel)

        episodeStack.axis = .vertical
        episodeStack.spacing = 8
        episodeStack.alignment = .leading
        episodeStack.addArrangedSubview(episodeLabelText)
        episodeStack.addArrangedSubview(episodeLabel)
    }
}
