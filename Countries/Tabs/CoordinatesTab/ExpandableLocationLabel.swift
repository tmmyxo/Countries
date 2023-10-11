//
//  LocationLabel.swift
//  Countries
//
//  Created by Artem Dolbiiev on 14.09.2023.
//

import UIKit

class ExpandableLocationLabel: UIView {

    private var isExpanded: Bool = false
    private var locationName = LocationName()

    private var widthConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    private var expandButtonHiddenStateTopConstraint: NSLayoutConstraint!
    private var expandButtonExposedStateTopConstraint: NSLayoutConstraint!

    lazy var locationLabel: LabelWithPadding = {
        let label = LabelWithPadding()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .systemBackground
        label.textColor = Colors.label
        label.textAlignment = .natural
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        label.contentInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        label.clipsToBounds = true
        label.layer.cornerRadius = 20
        label.layer.shadowColor = UIColor.darkGray.cgColor
        label.layer.shadowOpacity = 0.2
        label.layer.shadowRadius = 2
        label.layer.shadowOffset = CGSize(width: 0, height: 0)
        return label
    }()

    private lazy var locationLabelUnderlayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.backgroundColor
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        return view
    }()

    private lazy var expandLocationButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Colors.label
        button.backgroundColor = Colors.backgroundColor
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 11)
        button.setImage(UIImage(systemName: "arrow.down", withConfiguration: imageConfiguration), for: .normal)
        button.addTarget(self, action: #selector(didTriggerExpansionOrCompression), for: .touchUpInside)
        return button
    }()

    private lazy var notificationLabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(localized: "Copied")
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textColor = Colors.labelFlipped
        label.alpha = 0
        label.sizeToFit()
        return label
    }()

// MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupGestureRecognizers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        expandLocationButton.layer.cornerRadius = expandLocationButton.frame.height / 2
    }

    private func setupViews() {
        self.addSubviews(locationLabelUnderlayer)
        self.insertSubview(expandLocationButton, at: 0)
        locationLabelUnderlayer.addSubviews(locationLabel)
    }

// MARK: Constraints setup
    private func setupConstraints() {
        widthConstraint = locationLabel.widthAnchor.constraint(equalToConstant: 200)
        heightConstraint = locationLabel.heightAnchor.constraint(equalToConstant: 130)

        expandButtonExposedStateTopConstraint = expandLocationButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5)
        expandButtonHiddenStateTopConstraint = expandLocationButton.topAnchor.constraint(greaterThanOrEqualTo: locationLabel.topAnchor)

        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: self.topAnchor),
            locationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            locationLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
            locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor),
            widthConstraint,
            heightConstraint,

            locationLabelUnderlayer.topAnchor.constraint(equalTo: locationLabel.topAnchor),
            locationLabelUnderlayer.leadingAnchor.constraint(equalTo: locationLabel.leadingAnchor),
            locationLabelUnderlayer.bottomAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            locationLabelUnderlayer.trailingAnchor.constraint(equalTo: locationLabel.trailingAnchor),

            expandLocationButton.centerXAnchor.constraint(equalTo: locationLabel.centerXAnchor),
            expandButtonExposedStateTopConstraint,
            expandLocationButton.heightAnchor.constraint(equalToConstant: 20),
            expandLocationButton.widthAnchor.constraint(equalToConstant: 20),
            expandLocationButton.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor)
        ])
    }

    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTriggerExpansionOrCompression))
        self.addGestureRecognizer(tapGesture)

        let upSwipeGesture = UISwipeGestureRecognizer()
        upSwipeGesture.direction = [.up]
        upSwipeGesture.addTarget(self, action: #selector(setCompressedState))
        self.addGestureRecognizer(upSwipeGesture)

        let downSwipeGesture = UISwipeGestureRecognizer()
        downSwipeGesture.direction = [.down]
        downSwipeGesture.addTarget(self, action: #selector(setExpandedState))
        self.addGestureRecognizer(downSwipeGesture)
    }

    func setNewLocationName(_ locationName: LocationName, animated: Bool) {
        guard locationName != self.locationName else {
            return
        }
        self.locationName = locationName
        let locationText = self.isExpanded ? locationName.fullLocationName : locationName.shortLocationName
        if animated {
            animateLabelTextChange(for: locationText)
        } else {
            self.locationLabel.text = locationText
            updateLocationLabelSize(for: locationText)
        }
    }

    func getLocationName() -> String? {
        return self.locationLabel.text
    }

    // MARK: Expansion and compression
    @objc func didTriggerExpansionOrCompression() {
        if isExpanded {
            setCompressedState()
        } else {
            setExpandedState()
        }
    }

    @objc private func setExpandedState() {
        animateLabelTextChange(for: self.locationName.fullLocationName)
        animateExpansionButtonRotation()
        self.isExpanded = true
    }

    @objc private func setCompressedState() {
        animateLabelTextChange(for: self.locationName.shortLocationName)
        animateExpansionButtonRotation()
        self.isExpanded = false

    }

    private func updateLocationLabelSize(for text: String) {
        guard let superviewFrame = self.superview?.frame else {
            return
        }
        let padding = CGSize(width: 60, height: 0)
        let sizeFittingText = locationLabel.getSize(for: text, inside: superviewFrame, padding: padding)
        self.widthConstraint.constant = sizeFittingText.width + 3
        self.heightConstraint.constant = sizeFittingText.height + 3
    }
}

extension ExpandableLocationLabel {

    // MARK: Animations
    private func animateExpansionButtonRotation() {
        let angle = isExpanded ? (CGFloat.pi) : (CGFloat.pi * -1)
        let spin = CABasicAnimation(keyPath: "transform.rotation") // Using CABasicAnimation because UIView rotation animation is done in the shortest path.
        spin.duration = 0.3
        spin.fromValue = isExpanded ? (CGFloat.pi * -1) : 0
        spin.toValue = isExpanded ? 0 : angle
        expandLocationButton.layer.add(spin, forKey: "spinAnimation")
        CATransaction.setDisableActions(true)
        expandLocationButton.layer.transform = CATransform3DMakeRotation(isExpanded ? 0 : angle, 0, 0, 1)
    }

    private func animateLabelTextChange(for text: String) {
        // Using nested animation instead of keyFrame because the latest wasn't working as intended
        UIView.animate(withDuration: 0.10, delay: 0) {
            self.locationLabel.alpha = 0
        } completion: { _ in
            self.locationLabel.text = text
            UIView.animate(withDuration: 0.20) {
                self.locationLabel.text = text
                self.updateLocationLabelSize(for: text)
                self.superview?.layoutIfNeeded()
            } completion: { _ in
                UIView.animate(withDuration: 0.10) {
                    self.locationLabel.alpha = 1
                }
            }
        }
    }

    func showCopiedTextAnimation() {
        self.addSubviews(notificationLabel)
        NSLayoutConstraint.activate([
            notificationLabel.centerXAnchor.constraint(equalTo: self.locationLabelUnderlayer.centerXAnchor),
            notificationLabel.centerYAnchor.constraint(equalTo: self.locationLabelUnderlayer.centerYAnchor)
        ])
        UIView.animateKeyframes(withDuration: 1.1, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.1) {
                self.locationLabel.alpha = 0
                self.locationLabelUnderlayer.backgroundColor = Colors.detailMint
                self.notificationLabel.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.locationLabel.alpha = 1
                self.locationLabelUnderlayer.backgroundColor = Colors.secondaryBackground
                self.notificationLabel.alpha = 0
            }
        } completion: { _ in
            self.notificationLabel.removeFromSuperview()
        }
    }

    // MARK: Hide from user
    func hideFromUser(animated: Bool) {
        guard let superview = self.superview else {
            return
        }
        if animated {
            let ownBottomYPosition = self.frame.maxY
            let scale = CGAffineTransform.init(scaleX: 0.1, y: 1)

            let animationOptions = AnimationOptions.curveEaseIn
            let options = KeyframeAnimationOptions(rawValue: animationOptions.rawValue)

            self.expandButtonExposedStateTopConstraint.isActive = false
            self.expandButtonHiddenStateTopConstraint.isActive = true

            UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: options) {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                    superview.layoutIfNeeded()
                }
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3) {
                    let positionTranslation = CGAffineTransform(translationX: 0, y: (-ownBottomYPosition + (self.bounds.height)))
                    self.locationLabel.transform = scale
                    self.locationLabelUnderlayer.transform = scale
                    self.locationLabel.alpha = 0
                    self.transform = positionTranslation
                }
                UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.3) {
                    let positionTranslation = CGAffineTransform(translationX: 0, y: -ownBottomYPosition)
                    self.transform = positionTranslation
                }
            } completion: { _ in
                self.isHidden = true
                self.locationLabel.alpha = 1
                self.locationLabel.transform = .identity
                self.locationLabelUnderlayer.transform = .identity
                self.transform = .identity
            }
        } else {
            self.isHidden = true
        }
    }

    // MARK: Show to user
    func showToUser(animated: Bool) {
        guard let superview = self.superview else {
            return
        }
        if animated {
            self.expandButtonExposedStateTopConstraint.isActive = false
            self.expandButtonHiddenStateTopConstraint.isActive = true
            superview.layoutIfNeeded()

            let ownBottomYPosition = self.frame.maxY
            let scale = CGAffineTransform.init(scaleX: 0.1, y: 1)
            let position = CGAffineTransform(translationX: 0, y: -ownBottomYPosition)
            self.transform = scale.concatenating(position)
            self.isHidden = false

            let animationOptions = AnimationOptions.curveEaseOut
            let options = KeyframeAnimationOptions(rawValue: animationOptions.rawValue)

            UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: options) {

                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.35) {
                    let position1 = CGAffineTransform(translationX: 0, y: (-ownBottomYPosition + (self.bounds.height)))
                    let scale1 = CGAffineTransform(scaleX: 0.1, y: 1)
                    self.transform = position1.concatenating(scale1)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.35) {
                    self.transform = .identity
                }
                self.expandButtonExposedStateTopConstraint.isActive = true
                self.expandButtonHiddenStateTopConstraint.isActive = false

                UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
                    superview.layoutIfNeeded()
                }
            }
        } else {
            self.isHidden = false
        }
    }
}
