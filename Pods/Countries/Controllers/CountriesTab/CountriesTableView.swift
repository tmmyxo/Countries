//
//  ViewController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 26.03.2021.
//

import UIKit

class CountriesTableView: UITableViewController, UISearchBarDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    var viewModel = CountryViewModel()
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "countryCell")
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.titleView = searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.label
        definesPresentationContext = true
        viewModel.getJSONData()
        tableView.reloadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return viewModel.filteredCountries.count
        }
        return viewModel.countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        var country: Country
        if isFiltering{
            country = viewModel.filteredCountries[indexPath.row]
        } else {
            country = viewModel.countries[indexPath.row]
        }
        cell.textLabel?.text = country.name.common
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let DetailsViewController = CountryDetailsVC()
            if isFiltering {
                DetailsViewController.country = viewModel.filteredCountries[indexPath.row]
            } else {
                DetailsViewController.country = viewModel.countries[indexPath.row]
            }
            self.navigationController?.pushViewController(DetailsViewController, animated: true)
    }
}

extension CountriesTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        viewModel.filterContentForSearchText(searchBar.text!)
        tableView.reloadData()
    }
}
