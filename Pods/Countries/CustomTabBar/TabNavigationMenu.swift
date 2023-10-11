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
    var tabBarItems = [UIView]()
    var sliderPosition: NSLayoutConstraint?
    var sliderWidthConstraint: NSLayoutConstraint?
    
    var delegate: MapData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect){
        self.init(frame: frame)
        
        let itemWidth = self.frame.width / CGFloat(menuItems.count)
        
        sliderWidth = itemWidth - 45
        
        for i in 0 ..< menuItems.count {
            let leadingAnchor = itemWidth * CGFloat(i)
            let itemView = self.createTabItem(item: menuItems[i])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = i
            tabBarItems.append(itemView)
            self.addSubview(itemView)
            
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalTo: self.heightAnchor),
                itemView.widthAnchor.constraint(equalToConstant: itemWidth),
                itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor),
                itemView.topAnchor.constraint(equalTo: self.topAnchor)
            ])
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.backgroundColor = .systemBackground
        self.activateTab(tab: 0)
        self.addSubview(selectionSlider)
        selectionSlider.heightAnchor.constraint(equalToConstant: 6).isActive = true
        sliderWidthConstraint = selectionSlider.widthAnchor.constraint(equalToConstant: sliderWidth)
        sliderWidthConstraint?.isActive = true
        selectionSlider.centerYAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sliderPosition = selectionSlider.centerXAnchor.constraint(equalTo: tabBarItems[activeItem].centerXAnchor)
        sliderPosition?.isActive = true
        self.addSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(equalToConstant: 70),
            searchButton.widthAnchor.constraint(equalToConstant: 70),
            searchButton.centerXAnchor.constraint(equalTo: selectionSlider.centerXAnchor),
            searchButton.centerYAnchor.constraint(equalTo: selectionSlider.centerYAnchor),
        ])
        
        
    }
    
    override func draw(_ rect: CGRect) {
        drawTabBar()
    }
    
    //Overriding touch detection so that searchButton taps are registered properly outside of its parent view bounds
    //    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    //        let convertedPoint = searchButton.convert(point, from: self)
    //        return searchButton.point(inside: convertedPoint, with: event)
    //    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for subview in subviews.reversed() {
            let subPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(subPoint, with: event) {
                return result
            }
        }
        return nil
    }
    
    private var selectionSlider: UIView = {
        let slider = UIView()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.backgroundColor = UIColor.systemMint
        slider.layer.cornerRadius = 3
        return slider
    }()
    
    private let searchButton: CustomTabBarSearchButton = {
        let button = CustomTabBarSearchButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemMint.cgColor
        button.tintColor = .label
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        button.layer.cornerRadius = button.frame.width / 2
        button.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
        return button
    }()
    
    private func createTabItem(item: TabItem) -> UIView {
        let tabBarItem: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.clipsToBounds = true
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
            view.backgroundColor = .systemBackground
            return view
        }()
        
        let itemTitleLabel: UILabel = {
            let label = UILabel()
            label.text = item.displayTitle
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.clipsToBounds = true
            label.font = .systemFont(ofSize: 12)
            return label
        }()
        
        let itemIconView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = item.icon.withRenderingMode(.automatic)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.clipsToBounds = true
            imageView.tintColor = .label
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        tabBarItem.addSubviews(itemIconView, itemTitleLabel)
        
        NSLayoutConstraint.activate([
            itemIconView.heightAnchor.constraint(equalToConstant: 25),
            itemIconView.widthAnchor.constraint(equalToConstant: 30),
            itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemIconView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 7),
            
            itemTitleLabel.heightAnchor.constraint(equalToConstant: 13),
            itemTitleLabel.widthAnchor.constraint(equalTo: tabBarItem.widthAnchor),
            itemTitleLabel.topAnchor.constraint(equalTo: itemIconView.bottomAnchor, constant: 3)
        ])
        return tabBarItem
    }
    
    private func tabBarOutLinePath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        path.close()
        return path.cgPath
    }
    
    private func drawTabBar() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = tabBarOutLinePath()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        
        self.layer.insertSublayer(shapeLayer, at: 3)
        
        self.tabBarOutline = shapeLayer
    }
    
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        switchTab(from: activeItem, to: sender.view!.tag)
    }
    
    func switchTab(from: Int, to: Int) {
        activateTab(tab: to)
        let previousTab = self.subviews[from]
        let activeTab = self.subviews[to]
        
        if to == 1 {
            animateSearchButtonAppearence(centerBarView: self.subviews[1], movingFrom: previousTab)
        } else if from == 1 {
            animateSearchButtonDisappearence(centerBarView: self.subviews[1], movingTo: activeTab)
        } else {
            moveSlider(from: previousTab, to: activeTab)
        }
        
    }
    
    func activateTab(tab: Int) {
        self.itemTapped?(tab)
        self.activeItem = tab
    }
    
    func animateSearchButtonAppearence(centerBarView: UIView, movingFrom view: UIView) {
        searchButton.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        DispatchQueue.main.async {
            UIView.animateKeyframes(withDuration: 0.4, delay: 0) {
                
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
                    self.moveSlider(from: view, to: centerBarView)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.3) {
                    self.sliderWidthConstraint?.isActive = false
                    self.sliderWidthConstraint = self.selectionSlider.widthAnchor.constraint(equalToConstant: 8)
                    self.sliderWidthConstraint?.isActive = true
                    self.layoutIfNeeded()
                    self.searchButton.alpha = 1
                    centerBarView.alpha = 0
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.4) {
                    
                    self.searchButton.transform = .identity
                }
            } completion: { _ in
                centerBarView.isHidden = true
                self.searchButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func animateSearchButtonDisappearence(centerBarView: UIView, movingTo view: UIView) {
        DispatchQueue.main.async {
            centerBarView.isHidden = false
            UIView.animateKeyframes(withDuration: 0.4, delay: 0) {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
                    self.searchButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                    
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.3) {
                    self.sliderWidthConstraint?.isActive = false
                    self.sliderWidthConstraint = self.selectionSlider.widthAnchor.constraint(equalToConstant: self.sliderWidth)
                    self.sliderWidthConstraint?.isActive = true
                    self.searchButton.alpha = 0
                    centerBarView.alpha = 1
                    self.layoutIfNeeded()
                }
                UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.3) {
                    self.moveSlider(from: centerBarView, to: view)
                }
            } completion: { _ in
                self.searchButton.isUserInteractionEnabled = false
            }
        }
    }
    
    func moveSlider(from: UIView, to: UIView) {
        sliderPosition?.isActive = false
        sliderPosition = selectionSlider.centerXAnchor.constraint(equalTo: to.centerXAnchor)
        sliderPosition?.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func openSheet() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("TabBarSearchTapped"), object: nil)
    }
}


class CustomTabBarSearchButton: UIButton {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        generator.prepare()
        generator.impactOccurred()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.05) {
                self.isHighlighted = true
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                self.layer.shadowColor = UIColor.systemMint.cgColor
                self.layer.shadowRadius = 15
                self.layer.shadowOpacity = 0.7
                self.layer.shadowOffset = CGSize(width: 0, height: 0)
            }
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        generator.impactOccurred(intensity: 0.5)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.05) {
                self.isHighlighted = false
                self.transform = .identity
                self.layer.shadowRadius = 0
                self.layer.shadowOpacity = 0
            }
        }
    }
}
