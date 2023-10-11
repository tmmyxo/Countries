//
//  GameViewController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 30.09.2021.
//

import UIKit

class GameVC: UIViewController {
    
    var viewModel = CountryViewModel()
    var buttonConstraints = [ButtonSizeConstraints]()
    var countryToGuess = String()
    let generator = UINotificationFeedbackGenerator()
    var flagImages = [UIImage]()
    var score = 0 {
        didSet {
            navigationItem.rightBarButtonItem?.title = "Score: \(score)"
            saveScore()
        }
    }
    
    lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .label
        label.text = countryToGuess
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var firstCountryButton: UIButton = {
        var countryName = viewModel.countriesForGame[0].name.common
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = countryName
        button.imageView?.clipsToBounds = true
        button.imageView?.layer.cornerRadius = 5
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.tag = 0
        button.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var secondCountryButton: UIButton = {
        var countryName = viewModel.countriesForGame[1].name.common
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = countryName
        button.imageView?.clipsToBounds = true
        button.imageView?.layer.cornerRadius = 5
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.tag = 1
        button.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var thirdCountryButton: UIButton = {
        var countryName = viewModel.countriesForGame[2].name.common
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.text = countryName
        button.imageView?.clipsToBounds = true
        button.imageView?.layer.cornerRadius = 5
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 1, height: 1)
        button.layer.shadowRadius = 3
        button.tag = 2
        button.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        return button
    }()
    
    func setupConstraints() {
        let firstButtonHeight = firstCountryButton.heightAnchor.constraint(equalToConstant: 120)
        let firstButtonWidth = firstCountryButton.widthAnchor.constraint(equalToConstant: firstButtonHeight.constant * flagImages[0].getAspectRatio())
        
        let secondButtonHeight = secondCountryButton.heightAnchor.constraint(equalToConstant: 120)
        let secondButtonWidth = secondCountryButton.widthAnchor.constraint(equalToConstant: secondButtonHeight.constant * flagImages[1].getAspectRatio())
        
        let thirdButtonHeight = thirdCountryButton.heightAnchor.constraint(equalToConstant: 120)
        let thirdButtonWidth = thirdCountryButton.widthAnchor.constraint(equalToConstant: thirdButtonHeight.constant * flagImages[2].getAspectRatio())
        
        buttonConstraints.append(ButtonSizeConstraints(widthConstraint: firstButtonWidth, heightConstraint: firstButtonHeight))
        buttonConstraints.append(ButtonSizeConstraints(widthConstraint: secondButtonWidth, heightConstraint: secondButtonHeight))
        buttonConstraints.append(ButtonSizeConstraints(widthConstraint: thirdButtonWidth, heightConstraint: thirdButtonHeight))
    
        NSLayoutConstraint.activate([
            countryNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            countryNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countryNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            countryNameLabel.heightAnchor.constraint(equalToConstant: 30),
            
            firstCountryButton.topAnchor.constraint(equalTo: countryNameLabel.bottomAnchor, constant: 35),
            firstCountryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
            secondCountryButton.topAnchor.constraint(equalTo: firstCountryButton.bottomAnchor, constant: 30),
            secondCountryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            thirdCountryButton.topAnchor.constraint(equalTo: secondCountryButton.bottomAnchor, constant: 30),
            thirdCountryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        for button in buttonConstraints {
            button.heightConstraint.isActive = true
            button.widthConstraint.isActive = true
        }
    }
    
    func setupViews() {
        view.addSubviews(countryNameLabel, firstCountryButton, secondCountryButton, thirdCountryButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score \(score)")
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 19)], for: .normal)
        navigationItem.titleView?.removeFromSuperview()
        viewModel.getJSONData()
        startNewGame()
        generator.prepare()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveScore()
    }
    
    func startNewGame() {
        flagImages = [UIImage]()
        viewModel.selectThreeRandomCountries()
        countryToGuess = viewModel.countriesForGame.randomElement()!.name.common
        countryNameLabel.text = countryToGuess
        for i in 0...2 {
            flagImages.append(loadFlagImage(viewModel.countriesForGame[i].heightFixedFlagLink))
        }
        for (index, button) in [firstCountryButton, secondCountryButton, thirdCountryButton].enumerated() {
            button.setImage(flagImages[index], for: .normal)
        }
        updateButtonConstraints()
    }
    
    func saveScore() {
        guard let highScore = UserDefaults.standard.integer(forKey: "highscore") as? Int else { return }
        if score > highScore {
            UserDefaults.standard.set(score, forKey: "highscore")
        }
    }
    
    func updateButtonConstraints() {
        for (index, button) in buttonConstraints.enumerated() {
            button.widthConstraint.constant = button.heightConstraint.constant * flagImages[index].getAspectRatio()
        }
        view.layoutIfNeeded()
    }
    
    @objc func flagTapped(sender: UIButton!) {
        let chosenCountry = viewModel.countriesForGame[sender.tag].name.common
        if chosenCountry == countryToGuess {
            sender.tintColor = UIColor.green
            generator.notificationOccurred(.success)
            score += 1
        } else {
            sender.imageView?.tintColor = UIColor.red
            generator.notificationOccurred(.error)
        }
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            sender.tintColor = UIColor.green
        } completion: { _ in
            sender.transform = CGAffineTransform.identity
            self.startNewGame()
        }
    }
    
}

struct ButtonSizeConstraints {
    let widthConstraint: NSLayoutConstraint
    let heightConstraint: NSLayoutConstraint
}
