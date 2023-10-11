//
//  StartScreenViewController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 01.10.2021.
//

import UIKit

class StartScreenVC: UIViewController {

    private var viewModel = StartScreenVM()

    private var highscore: Int = 0 

    private lazy var startButton: NeumorphicButton = {
        let button = NeumorphicButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(localized: "Start"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(Colors.detailMint, for: .normal)
        button.backgroundColor = Colors.secondaryBackground
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        return button
    }()

    private lazy var chooseButton: NeumorphicButton = {
        let button = NeumorphicButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(String(localized: "Choose countries"), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(Colors.detailRed, for: .normal)
        button.backgroundColor = Colors.secondaryBackground
        button.layer.cornerRadius = 28
        button.addTarget(self, action: #selector(chooseCountries), for: .touchUpInside)
        return button
    }()

    private lazy var highscoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = Colors.label
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.sizeToFit()
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(resetHighScore))
        label.addGestureRecognizer(swipe)
        return label
    }()

    private lazy var resetHighscoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.backgroundColor = Colors.secondaryBackground
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        button.setImage(UIImage(systemName: "arrow.counterclockwise", withConfiguration: imageConfiguration), for: .normal)
        button.addTarget(self, action: #selector(resetHighScore), for: .touchUpInside)
        button.tintColor = Colors.label
        return button
    }()

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.secondaryBackground
        view.addSubviews(startButton, chooseButton, highscoreLabel, resetHighscoreButton)
        setupConstraints()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .label
    }

    override func viewDidLayoutSubviews() {
        resetHighscoreButton.layer.cornerRadius = resetHighscoreButton.frame.height / 2
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        let storedHighscore = UserDefaults.standard.integer(forKey: "highscore")
        highscore = storedHighscore
        highscoreLabel.text = String(localized: "High score: \(highscore)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: Constraints setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 230),
            startButton.heightAnchor.constraint(equalToConstant: 56),
            startButton.widthAnchor.constraint(equalToConstant: 210),

            chooseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chooseButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 25),
            chooseButton.heightAnchor.constraint(equalToConstant: 56),
            chooseButton.widthAnchor.constraint(equalToConstant: 210),

            highscoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            highscoreLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),

            resetHighscoreButton.leadingAnchor.constraint(equalTo: highscoreLabel.trailingAnchor, constant: 10),
            resetHighscoreButton.centerYAnchor.constraint(equalTo: highscoreLabel.centerYAnchor),
            resetHighscoreButton.heightAnchor.constraint(equalToConstant: 30),
            resetHighscoreButton.widthAnchor.constraint(equalToConstant: 30)

        ])
    }
}

extension StartScreenVC {

    // MARK: Actions
    @objc func startGame() {
        let selectedCountries = viewModel.getCountriesSelectedForGame()
        guard selectedCountries.count >= 3 else {
            let warningText = String(localized: "You must select at least 3 countries to start a game")
            self.displayNotificationToUser(title: String(localized: "Warning!"), text: warningText, prefferedStyle: .alert, action: nil)
            return
        }
        let gameVC = GameVC(selectedCountries: selectedCountries)
        navigationController?.pushViewController(gameVC, animated: true)
    }
    
    @objc func chooseCountries() {
        let allCountries = viewModel.getCountries()
        let selectorVC = CountrySelectorVC(countries: allCountries)
        selectorVC.selectorDelegate = self
        let navController = UINavigationController(rootViewController: selectorVC)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    @objc func resetHighScore() {
        highscore = 0
        UserDefaults.standard.set(highscore, forKey: "highscore")
        animateScoreReset()
    }
}

extension StartScreenVC: CountrySelector {
    func didChangeCountriesSelected(countries: [Country]) {
        viewModel.updateCountries(with: countries)
    }
}


extension StartScreenVC {

    // MARK: Animations
    private func animateScoreReset() {
        rotateScoreButton()
        resetScoreLabelText()
    }

    private func rotateScoreButton() {
        let angle = CGFloat.pi * -2
        let spin = CABasicAnimation(keyPath: "transform.rotation")
        spin.duration = 0.4
        spin.fromValue = 0
        spin.toValue = angle
        resetHighscoreButton.layer.add(spin, forKey: "spinAnimation")
        CATransaction.setDisableActions(true)
        resetHighscoreButton.layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
    }

    private func resetScoreLabelText() {
        self.highscoreLabel.text = String(localized: "High score: \(self.highscore)")
        self.highscoreLabel.fadeInLeftToRight(duration: 0.3)
    }
}

#Preview {
    StartScreenVC()
}
