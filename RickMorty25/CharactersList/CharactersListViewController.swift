//
//  CharactersListViewController.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import UIKit
import SnapKit

class CharactersListViewController: UIViewController {

    let viewModel: CharactersListViewModel
    let activityIndicator = UIActivityIndicatorView()

    private let mainLabel: UILabel = {
        let label = UILabel()
        label.text = "The Rick and Morty"
        label.font = Fonts.customSuperHuge
        label.textAlignment = .center
        label.textColor = .secondaryTxtColor
        label.backgroundColor = .secondaryBackColor
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CharactersTableViewCell.self, forCellReuseIdentifier: CharactersTableViewCell.identifier)
        return tableView
    }()

    init(viewModel: CharactersListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mainLabel)
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self

        viewModel.reloadTableView = { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
        }

        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        setupActivityIndicator()

        viewModel.onCharacterSelected = {[weak self] character in
            let characterViewModel = CharacterViewModel(character: character)
            let characterViewController = CharacterViewController(viewModel: characterViewModel)
            self?.navigationController?.pushViewController(characterViewController, animated: true)
        }
    }

    private func setupActivityIndicator() {
        activityIndicator.style = .large
        activityIndicator.color = .yellow

        view.addSubview(activityIndicator)

        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}

extension CharactersListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character = viewModel.characters[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableViewCell.identifier, for: indexPath) as! CharactersTableViewCell
        cell.configure(with: character)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCharacter(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = viewModel.numberOfItems() - 1
        if indexPath.row == lastIndex {
            activityIndicator.startAnimating()
            viewModel.loadMoreData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        if currentOffset < 0 {
            tableView.reloadData()
        }
    }
}
