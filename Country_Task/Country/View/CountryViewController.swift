//
//  CountryViewController.swift
//  Country_Task
//
//  Created by Mohamed Elkazzaz on 25/02/2025.
//

import UIKit

class CountryViewController: UIViewController {
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var noFoundImage: UIImageView!
    @IBOutlet weak var filterCountrySearch: UISearchBar!
    @IBOutlet weak var countryView: UIView!
    
    private let viewModel: HomeViewModel = HomeViewModel(
          countryService: CountryService(),
          locationManager: LocationManager()
      )
    override func viewDidLoad() {
        super.viewDidLoad()

        countryView.isHidden = true
        noFoundImage.isHidden = true
        countryTableView.isEditing = false
        
        
        countryTableView.delegate = self
        countryTableView.dataSource = self
        
        filterCountrySearch.delegate = self
        setupBindings()
        viewModel.loadCountries()
    }
    
    private func setupBindings() {
           viewModel.onCountriesUpdate = { [weak self] in
               DispatchQueue.main.async {
                   self?.countryTableView.reloadData()
               }
           }
       }

}

extension CountryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
           return 2
       }
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if viewModel.filteredCountries.isEmpty {
               countryTableView.isHidden = true
               countryView.isHidden = false
               noFoundImage.isHidden = false
           }else{
               countryTableView.isHidden = false
               countryView.isHidden = true
               noFoundImage.isHidden = true
           }
           return section == 0 ? viewModel.pinnedCountries.count : viewModel.filteredCountries.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
           let country = (indexPath.section == 0)
               ? viewModel.pinnedCountries[indexPath.row]
               : viewModel.filteredCountries[indexPath.row]
           cell.selectionStyle = .none
           cell.textLabel?.text = country.name
           cell.detailTextLabel?.text = country.capital ?? "No capital"
           return cell
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           // On selection, navigate to detail screen
           let country = (indexPath.section == 0)
               ? viewModel.pinnedCountries[indexPath.row]
               : viewModel.filteredCountries[indexPath.row]
//           
//           let detailVC = CountryDetailViewController(country: country)
//           navigationController?.pushViewController(detailVC, animated: true)
       }
       
       
       func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return indexPath.section == 0
       }
       
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                      forRowAt indexPath: IndexPath) {
           if editingStyle == .delete && indexPath.section == 0 {
               viewModel.removePinnedCountry(at: indexPath.row)
           }
       }
    
    
}

extension CountryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            viewModel.searchText = searchText
        }
}
