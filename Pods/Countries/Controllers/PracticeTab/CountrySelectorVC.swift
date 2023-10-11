//
//  countrySelectorViewController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 07.10.2021.
//

import Foundation
import UIKit

class CountrySelectorVC: UITableViewController {
    
    let viewModel = CountryViewModel()
    var selectionStatus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getJSONData()
        loadSelection()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SelectorCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(selectAllCountries))
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], for: .normal)
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], for: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveSelection()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectorCell", for: indexPath)
        let country = viewModel.countries[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.countries[indexPath.row].name.common
        cell.contentConfiguration = content
        cell.accessoryType = country.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        cell.tintColor = UIColor(red: 0.16, green: 0.88, blue: 0.75, alpha: 1.00)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.countries[indexPath.row].isSelected.toggle()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func selectAllCountries() {
        selectionStatus.toggle()
        for index in 0..<viewModel.countries.count {
            viewModel.countries[index].isSelected = selectionStatus
        }
        tableView.reloadData()
    }
    
    @objc func saveSelection() {
        let selectedCountries = viewModel.countries.filter{$0.isSelected}.map{$0.name.common}
        UserDefaults.standard.set(selectedCountries, forKey: "selectedCountries")
    }
    
    func loadSelection() {
        guard let selectedCountries = UserDefaults.standard.array(forKey: "selectedCountries") as? [String] else { return }
        for (index, country) in viewModel.countries.enumerated() {
            viewModel.countries[index].isSelected = selectedCountries.contains(country.name.common)
        }
    }
    
    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}
