//
//  LaunchScreenViewController.swift
//  Marusya_Habits
//
//  Created by Мария Александрова on 12.01.2026.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    private var titleApp: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "MyHabits"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = UIColor.purpleHabits
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private lazy var iconMainImageView: UIImageView = {
        let avatarImageView = UIImageView()
        let imageName = "main_icon"
        if let image = UIImage(named: imageName) {
            avatarImageView.image = image
        } else {
            avatarImageView.tintColor = .gray
            avatarImageView.image = UIImage(systemName: "photo")
        }
        avatarImageView.layer.cornerRadius = 0
        avatarImageView.layer.borderWidth = 0
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews([titleApp, iconMainImageView])
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            iconMainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconMainImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            iconMainImageView.heightAnchor.constraint(equalToConstant: 120),
            iconMainImageView.widthAnchor.constraint(equalToConstant: 120),
            
            titleApp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            titleApp.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}
