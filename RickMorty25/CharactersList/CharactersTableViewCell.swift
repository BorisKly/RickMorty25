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

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = Fonts.customBody2
        label.textColor = .txtColor
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        contentView.backgroundColor = .backColor
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with character: CharacterResponse) {
        nameLabel.text = character.name
        setCharacterImage(from: character.image)
       }

    private func setCharacterImage(from urlString: String) {
        print(#function)
        guard let url = URL(string: urlString) else {
            print("wrong URL")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error loading: \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Imposible create image")
                return
            }

            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
        }
        .resume()
    }

    private func setupView() {
        addSubview(profileImageView)
        addSubview(nameLabel)

        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalToSuperview().offset(24)
            make.left.equalToSuperview().offset(16)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.equalToSuperview().offset(-24)
        }
    }
}
