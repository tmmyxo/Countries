//
//  GameViewController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 30.09.2021.
//

import UIKit

class GameVC: UIViewController {

    private var viewModel: GameViewModel
    private let generator = UINotificationFeedbackGenerator()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.label
        label.font = .boldSystemFont(ofSize: 19)
        return label
    }()

    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        let imgConfig = UIImage.SymbolConfiguration(scale: .large)
        backButton.setImage(UIImage(systemName: "chevron.backward", withConfiguration: imgConfig), for: .normal)
        backButton.tintColor = Colors.label
        backButton.addTarget(self, action: #selector(showFinalResultAndPop), for: .touchUpInside)
        return backButton
    }()

    private lazy var countryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = Colors.label
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var flagButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 35
        return stackView
    }()

    private lazy var firstCountryButton: FlagButton = {
        let button = FlagButton(type: .custom)
        button.tag = 0
        button.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        return button
    }()

    private lazy var secondCountryButton: FlagButton = {
        let button = FlagButton(type: .custom)
        button.tag = 1
        button.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        return button
    }()

    private lazy var thirdCountryButton: FlagButton = {
        let button = FlagButton(type: .custom)
        button.tag = 2
        button.addTarget(self, action: #selector(flagTapped), for: .touchUpInside)
        return button
    }()

    init(selectedCountries: [Country]) {
        self.viewModel = GameViewModel(selectedCountries: selectedCountries)
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.secondaryBackground
        setupNavigationBar()
        setupErrorHandling()
        setupLoadingIndicator()

        viewModel.score.bind { score in
            self.scoreLabel.text = String(localized: "Score: \(score)")
            self.scoreLabel.sizeToFit()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        hideTabNavigationMenu()
        viewModel.startNewGame { countries, countryToGuess  in
            self.setupViews()
            self.setupConstraints()
            self.updateButtons(with: countries)
            self.countryNameLabel.text = countryToGuess
            self.countryNameLabel.sizeToFit()
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.removeFromSuperview()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.saveScore()
        showTabNavigationMenu()
    }

    override func viewWillLayoutSubviews() {
        self.countryNameLabel.sizeToFit()
    }

    // MARK: Views setup
    private func setupViews() {
        view.addSubviews(countryNameLabel, flagButtonsStack)
        flagButtonsStack.addArrangedSubview(firstCountryButton)
        flagButtonsStack.addArrangedSubview(secondCountryButton)
        flagButtonsStack.addArrangedSubview(thirdCountryButton)
    }

    // MARK: Constraints setup
    private func setupConstraints() {

        NSLayoutConstraint.activate([
            countryNameLabel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            countryNameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            countryNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            countryNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countryNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            flagButtonsStack.topAnchor.constraint(equalTo: countryNameLabel.bottomAnchor, constant: 40),
            flagButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 75),
            flagButtonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            flagButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -75)
        ])
    }

    private func setupLoadingIndicator() {
        self.view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 50)
        ])
        loadingIndicator.startAnimating()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: scoreLabel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.titleView?.removeFromSuperview()
    }

    private func setupErrorHandling() {
        viewModel.errorHandler = { error in
            self.displayNotificationToUser(title: String(localized: "Error"), text: "\(error.localizedDescription)", prefferedStyle: .alert) { alertAction in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func updateButtons(with countries: [Country]) {
        for (index, button) in [firstCountryButton, secondCountryButton, thirdCountryButton].enumerated() {
            button.setRoundedImage(image: countries[index].flagImage)
        }
    }
}

extension GameVC {
    // MARK: Start New Round
    private func startNewRound() {
        viewModel.startNextRound { nextCountries, countryToGuess in
            self.updateButtons(with: nextCountries)
            self.flagButtonsStack.isUserInteractionEnabled = true
            self.countryNameLabel.text = countryToGuess
            self.revertBackground()
        }
    }

    // MARK: Animations
    private func reactToUserChoice(_ isRight: Bool) {
        let feedbackType: UINotificationFeedbackGenerator.FeedbackType = isRight ? .success : .error
        let successColor = Colors.detailMint
        let failureColor = Colors.detailRed
        let reactionColor = isRight ? successColor : failureColor
        generator.notificationOccurred(feedbackType)

        UIView.animate(withDuration: 0.2) {
            self.navigationController?.navigationBar.backgroundColor = reactionColor
            self.view.backgroundColor = reactionColor
            self.navigationController?.navigationBar.layoutIfNeeded()
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.startNewRound()
            }
        }
    }

    private func revertBackground() {
        UIView.animate(withDuration: 0.2) {
            self.navigationController?.navigationBar.backgroundColor = Colors.secondaryBackground
            self.navigationController?.navigationBar.layoutIfNeeded()
            self.view.backgroundColor = Colors.secondaryBackground
        }
    }

    private func createFinalResultLabel() -> UIView {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "You scored: \n\(viewModel.score.value)/\(viewModel.questionsAnswered)")
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.alpha = 0
        label.sizeToFit()
        return label
    }
}

extension GameVC {

    @objc func showFinalResultAndPop() {
        let finalResultLabel = self.createFinalResultLabel()

        UIView.animateKeyframes(withDuration: 0.8, delay: 0) {

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.countryNameLabel.alpha = 0
                self.flagButtonsStack.alpha = 0
                self.scoreLabel.alpha = 0
                self.backButton.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                finalResultLabel.alpha = 1
            }
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                UIView.animate(withDuration: 0.4) {
                    finalResultLabel.alpha = 0
                } completion: { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    // MARK: Flag tapped
    @objc func flagTapped(sender: UIButton!) {
        flagButtonsStack.isUserInteractionEnabled = false

        let isTheRightChoice = viewModel.isSelectedCountryRight(at: sender.tag)
        reactToUserChoice(isTheRightChoice)
        isTheRightChoice ? viewModel.increaseScore() : nil
    }
}

#Preview {
    let countries = StartScreenVM().getCountriesSelectedForGame()
    let view = UINavigationController(rootViewController: GameVC(selectedCountries: countries))
    return view
}
