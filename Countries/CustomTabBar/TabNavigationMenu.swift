//
//  TabNavigationMenu.swift
//  Countries
//
//  Created by Artem Dolbiev on 06.12.2021.
//

import UIKit

class TabNavigationMenu: UIView {
    
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    var sliderWidth: CGFloat = 0
    var tabBarOutline: CALayer?
    var tabBarViews = [UIView]() /// check if it's needed
    var sliderPosition: NSLayoutConstraint!
    var sliderWidthConstraint: NSLayoutConstraint!

    private lazy var menuItemsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var searchButton: CustomTabBarSearchButton = {
        let button = CustomTabBarSearchButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.secondaryBackground
        button.layer.borderWidth = 2
        button.layer.borderColor = Colors.detailMint.cgColor
        button.tintColor = .label
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        button.layer.cornerRadius = button.frame.width / 2
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
        return button
    }()

    private var selectionSlider: UIView = {
        let slider = UIView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.backgroundColor = Colors.detailMint
        slider.layer.cornerRadius = 3
        return slider
    }()

    // MARK: Init
    init(tabItems: [TabItem], frame: CGRect) {
        super.init(frame: frame)
        self.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.2
        
        sliderWidth = (self.bounds.width / CGFloat(tabItems.count)) - 45
        setupTabStackView()
        setupTabViews(for: tabItems)
        self.activateTab(tab: 0)
        setupSelectionSlider()
        setupSearchButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews.reversed() {
            let subPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(subPoint, with: event) {
                return result
            }
        }
        return nil
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        searchButton.layer.borderColor = Colors.detailMint.cgColor
    }

    private func setupTabViews(for tabItems: [TabItem]) {
        for (index, tabItem) in tabItems.enumerated() {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMenuItem))
            let itemView = TabItemView(tabItem: tabItem)
            itemView.tag = index
            itemView.addGestureRecognizer(tapGestureRecognizer)
            tabBarViews.append(itemView)
            menuItemsStack.addArrangedSubview(itemView)
        }
    }

    private func setupTabStackView() {
        self.addSubview(menuItemsStack)
        NSLayoutConstraint.activate([
            menuItemsStack.topAnchor.constraint(equalTo: self.topAnchor),
            menuItemsStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            menuItemsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            menuItemsStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    private func setupSearchButton() {
        self.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(equalToConstant: 70),
            searchButton.widthAnchor.constraint(equalToConstant: 70),
            searchButton.centerXAnchor.constraint(equalTo: selectionSlider.centerXAnchor),
            searchButton.centerYAnchor.constraint(equalTo: selectionSlider.centerYAnchor),
        ])
        bringSubviewToFront(searchButton)
    }

    private func setupSelectionSlider() {
        self.addSubview(selectionSlider)
        sliderWidthConstraint = selectionSlider.widthAnchor.constraint(equalToConstant: sliderWidth)
        sliderPosition = selectionSlider.centerXAnchor.constraint(equalTo: tabBarViews[activeItem].centerXAnchor)

        NSLayoutConstraint.activate([
            selectionSlider.heightAnchor.constraint(equalToConstant: 6),
            selectionSlider.centerYAnchor.constraint(equalTo: self.topAnchor),
            sliderWidthConstraint,
            sliderPosition
        ])
    }
}

extension TabNavigationMenu {

    // MARK: Actions
    @objc func openSheet() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("TabBarSearchTapped"), object: nil)
    }

    @objc func didTapMenuItem(_ sender: UIGestureRecognizer) {
        switchTab(from: activeItem, to: sender.view!.tag)
    }

    private func switchTab(from currentTabIndex: Int, to selectedTabIndex: Int) {
        activateTab(tab: selectedTabIndex)
        let activeTab = self.tabBarViews[currentTabIndex]
        let selectedTab = self.tabBarViews[selectedTabIndex]

        if selectedTabIndex == 1 {
            animateSearchButtonAppearence(centerBarView: self.tabBarViews[1])
        } else if currentTabIndex == 1 {
            animateSearchButtonDisappearence(centerBarView: self.tabBarViews[1], movingTo: selectedTab)
        } else {
            moveSlider(from: activeTab, to: selectedTab)
        }
    }

    private func activateTab(tab: Int) {
        self.itemTapped?(tab)
        self.activeItem = tab
    }
}

extension TabNavigationMenu {

    // MARK: Animations
    private func animateSearchButtonAppearence(centerBarView: UIView) {
        searchButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        DispatchQueue.main.async {

            UIView.animateKeyframes(withDuration: 0.4, delay: 0) {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7) {
                    self.sliderPosition?.isActive = false
                    self.sliderPosition = self.selectionSlider.centerXAnchor.constraint(equalTo: self.tabBarViews[1].centerXAnchor)
                    self.sliderPosition?.isActive = true
                    self.sliderWidthConstraint?.isActive = false
                    self.sliderWidthConstraint = self.selectionSlider.widthAnchor.constraint(equalToConstant: 8)
                    self.sliderWidthConstraint?.isActive = true
                    self.layoutIfNeeded()
                    self.searchButton.alpha = 1
                    centerBarView.alpha = 0
                }
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
                    self.searchButton.transform = .identity
                }
            } completion: { _ in
                centerBarView.isUserInteractionEnabled = false
                self.searchButton.isUserInteractionEnabled = true
            }
        }
    }

    private func animateSearchButtonDisappearence(centerBarView: UIView, movingTo view: UIView) {
        centerBarView.isHidden = false

        UIView.animateKeyframes(withDuration: 0.4, delay: 0) {

            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7) {
                self.searchButton.transform = CGAffineTransform(scaleX: 0, y: 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
                self.sliderWidthConstraint?.isActive = false
                self.sliderWidthConstraint = self.selectionSlider.widthAnchor.constraint(equalToConstant: self.sliderWidth)
                self.sliderWidthConstraint?.isActive = true
                self.searchButton.alpha = 0
                centerBarView.alpha = 1
                self.sliderPosition?.isActive = false
                self.sliderPosition = self.selectionSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor)
                self.sliderPosition?.isActive = true
                self.layoutIfNeeded()
            }
        } completion: { _ in
            centerBarView.isUserInteractionEnabled = true
            self.searchButton.isUserInteractionEnabled = false
        }
    }

   private func moveSlider(from: UIView, to: UIView) {
        sliderPosition?.isActive = false
        sliderPosition = selectionSlider.centerXAnchor.constraint(equalTo: to.centerXAnchor)
        sliderPosition?.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
