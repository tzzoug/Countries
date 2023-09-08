//
//  AllCountriesViewController.swift
//  FavCountries
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import UIKit
import Combine

class AllCountriesViewController: UIViewController {
    
    var viewModel: AllCountriesViewModel

    @IBOutlet weak var allCountriesTableView: UITableView!
    
    private var cancellables: Set<AnyCancellable> = []
    // This is to avoid doing UI updates when the view controller is not visible
    private var visible: Bool = false
    
    init?(coder: NSCoder, viewModel: AllCountriesViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Countries"
        
        allCountriesTableView.delegate = self
        allCountriesTableView.dataSource = self
        allCountriesTableView.register(UINib(nibName: "CountryCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryCellTableViewCell")

        viewModel.$countryCellViewModels.sink { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.allCountriesTableView.reloadData()
            }
        }
        .store(in: &cancellables)
        
        viewModel.$updatedCountryCellViewModelIndex.sink { [weak self] index in
            guard let self, visible else { return }
            allCountriesTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        }
        .store(in: &cancellables)
        
        Task {
            await self.viewModel.viewDidLoad()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        visible = true
        
        self.allCountriesTableView.reloadData()
        
        if let selectedIndexPath = allCountriesTableView.indexPathForSelectedRow {
            allCountriesTableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        visible = false
    }
}

extension AllCountriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countryCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCellTableViewCell", for: indexPath) as? CountryCellTableViewCell  {
            cell.setup(with: viewModel.countryCellViewModels[indexPath.row])
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(index: indexPath.row)
    }
}

extension AllCountriesViewController: CountryCellTableViewCellDelegate {
    func didToggleFavorite(countryId: String) {
        viewModel.onFavoriteToggle(countryId: countryId)
    }
}
