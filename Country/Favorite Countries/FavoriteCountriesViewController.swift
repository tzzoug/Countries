//
//  FavoriteCountriesViewController.swift
//  FavCountries
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import UIKit
import Combine

class FavoriteCountriesViewController: UIViewController {
    
    var viewModel: FavoriteCountriesViewModel

    @IBOutlet weak var tableView: UITableView!
    
    private var cancellables: Set<AnyCancellable> = []

    init?(coder: NSCoder, viewModel: FavoriteCountriesViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) { fatalError("You must create this view controller with a user.") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorite Countries"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CountryCellTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryCellTableViewCell")

        viewModel.$countryCellViewModels.sink { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        .store(in: &cancellables)
        
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}

extension FavoriteCountriesViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            viewModel.didDelete(index: indexPath.row)
        }
    }
}

extension FavoriteCountriesViewController: CountryCellTableViewCellDelegate {
    func didToggleFavorite(countryId: String) {
        viewModel.didToggleFavorite(countryId: countryId)
    }
}
