//
//  CustomTableViewCell.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 27.10.2021.
//

import Foundation
import UIKit

class PlacesTableViewCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 1.00, green: 0.42, blue: 0.42, alpha: 1.00)
        view.layer.cornerRadius = 13
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let placeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .tertiarySystemBackground
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        addSubview(cellView)
        cellView.addSubview(placeNameLabel)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            placeNameLabel.heightAnchor.constraint(equalToConstant: 50),
            placeNameLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 15),
            placeNameLabel.rightAnchor.constraint(equalTo: cellView.rightAnchor, constant: -20),
            placeNameLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor)
        ])
    }
}
