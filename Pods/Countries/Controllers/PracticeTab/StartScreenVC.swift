//
//  StartScreenViewController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 01.10.2021.
//

import UIKit

class StartScreenVC: UIViewController {
    
    var highscore: Int = 0 {
        didSet {
            highscoreLabel.text = "High score: \(self.highscore)"
        }
    }
    
    lazy var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.titleLabel?.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor(red: 0.16, green: 0.88, blue: 0.75, alpha: 1.00)
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        
        return button
    }()
    
    lazy var chooseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Choose countries", for: .normal)
        button.titleLabel?.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.cornerRadius = 28
        button.backgroundColor = UIColor(red: 1.00, green: 0.42, blue: 0.42, alpha: 1.00)
        button.addTarget(self, action: #selector(chooseCountries), for: .touchUpInside)
        return button
    }()
    
    lazy var highscoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .label
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(resetHighScore))
        label.addGestureRecognizer(swipe)
        return label
    }()
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 230),
            startButton.heightAnchor.constraint(equalToConstant: 55),
            startButton.widthAnchor.constraint(equalToConstant: 210),
            
            chooseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 20),
            chooseButton.heightAnchor.constraint(equalToConstant: 55),
            chooseButton.widthAnchor.constraint(equalToConstant: 210),
            
            highscoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            highscoreLabel.heightAnchor.constraint(equalToConstant: 40),
            highscoreLabel.widthAnchor.constraint(equalToConstant: 300),
            highscoreLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        let storedHighscore = UserDefaults.standard.integer(forKey: "highscore")
        highscore = storedHighscore
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(startButton, chooseButton, highscoreLabel)
        setupConstraints()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .label
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc func startGame() {
        let gameVC = GameVC()
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc func chooseCountries() {
        let selectorVC = CountrySelectorVC()
        let navController = UINavigationController(rootViewController: selectorVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
//        present(selectorVC, animated: true)
    }
    
    @objc func resetHighScore() {
        UserDefaults.standard.set(0, forKey: "highscore")
        highscore = UserDefaults.standard.integer(forKey: "highscore")
    }
    
}
