//
//  CharacterViewController.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import UIKit

class CharacterViewController: UIViewController {

    var viewModel: CharacterViewModel

    public var mainView: CharacterView? {
        return self.view as? CharacterView
    }

    init(viewModel: CharacterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let codeView = CharacterView(frame: CGRect.zero)
        self.view = codeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView?.nameLabel.text = viewModel.character.name
        mainView?.statusLabel.text = viewModel.character.status
        mainView?.genderLabel.text = viewModel.character.gender
        mainView?.locationLabel.text = viewModel.character.location.name
        loadImage(from: viewModel.character.image) { [weak self] image in
            self?.mainView?.profileImageView.image = image ?? UIImage(named: "photo")
        }
        viewModel.onEpisodeUpdated = { [weak self] episode in
            self?.mainView?.episodeLabel.text = episode?.name
        }
    }
}
