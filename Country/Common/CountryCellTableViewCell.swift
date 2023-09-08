//
//  CountryCellTableViewCell.swift
//  Country
//
//  Created by Shirag Berejikian on 2023-09-08.
//

import UIKit

protocol CountryCellTableViewCellDelegate: AnyObject {
    func didToggleFavorite(countryId: String)
}

class CountryCellTableViewCell: UITableViewCell {
    weak var delegate: CountryCellTableViewCellDelegate?
    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var rightButtonView: UIButton!
    
    @IBAction func rightButtonAction(_ sender: Any) {
        if let viewModel {
            delegate?.didToggleFavorite(countryId: viewModel.country.id)
        }
    }
    
    private var viewModel: CountryCellViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        rightButtonView.imageView?.image = nil
    }
    
    func setup(with viewModel: CountryCellViewModel) {
        self.viewModel = viewModel
        
        leftImageView.load(url: viewModel.flagImageUrl)
        titleLabel.text = viewModel.name
        
        if viewModel.isFavorited {
            rightButtonView.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            rightButtonView.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}
