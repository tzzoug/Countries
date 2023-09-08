//
//  CountryDetailViewController.swift
//  Country
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import UIKit
import Combine

class CountryDetailViewController: UIViewController {
    var viewModel: CountryDetailViewModel

    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    @IBAction func starButtonAction(_ sender: Any) {
        viewModel.didToggleFavorite()
    }
    
    private var cancellable: AnyCancellable?

    init?(coder: NSCoder, viewModel: CountryDetailViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    override func viewDidLoad() {
        title = viewModel.name
        topImageView.load(url: viewModel.flagImageUrl)
        firstLabel.text = "Capital(s): \(viewModel.capitals)"
        secondLabel.text = "Continent(s): \(viewModel.continents)"
        thirdLabel.text = "Population: \(viewModel.population)"
        fourthLabel.text = "Favorite:"
        
        self.cancellable = viewModel.$isFavorited.sink { [weak self] isFavorited in
            guard let self else { return }
            DispatchQueue.main.async {
                self.starButton.imageView?.image = isFavorited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
            }
        }
    }
}
