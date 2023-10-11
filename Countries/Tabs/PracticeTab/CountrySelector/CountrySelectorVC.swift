//
//  countrySelectorViewController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 07.10.2021.
//

import Foundation
import UIKit

protocol CountrySelector: AnyObject {
    func didChangeCountriesSelected(countries: [Country])
}

class CountrySelectorVC: UITableViewController {

    let viewModel: CountrySelectorVM

    weak var selectorDelegate: CountrySelector?

    init(countries: [Country]) {
        self.viewModel = CountrySelectorVM(countries: countries)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = Colors.secondaryBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SelectorCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: String(localized: "Select All"), style: .plain, target: self, action: #selector(selectAllCountries))
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], for: .normal)
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)], for: .normal)
    }

    override func viewWillDisappear(_ animated: Bool) {
        let countries = viewModel.getCountries()
        selectorDelegate?.didChangeCountriesSelected(countries: countries)
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel.saveSelection()
    }
}

extension CountrySelectorVC {

    // MARK: TableView methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getCountriesCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectorCell", for: indexPath)
        let country = viewModel.getCountry(at: indexPath.row)
        configureCell(for: cell, country: country)
        cell.backgroundColor = Colors.secondaryBackground
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.changeCountrySelectionStatus(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    private func configureCell(for cell: UITableViewCell, country: Country) {
        var content = cell.defaultContentConfiguration()
        content.text = country.name.common
        cell.contentConfiguration = content
        cell.accessoryType = country.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        cell.tintColor = Colors.detailMint
    }
}

extension CountrySelectorVC {

    // MARK: Actions
    @objc func selectAllCountries() {
        viewModel.toggleAllCountriesSelectionStatus()
        tableView.reloadData()
    }

    @objc func dismissView() {
        self.dismiss(animated: true)
    }
}
