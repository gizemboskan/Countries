//
//  CountryListTableViewCell.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit

final class CountryListTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var favButton: UIButton! {
        didSet {
            favButton.imageView?.alpha = 0.3
        }
    }
    
    // MARK: - Initilizations
    override func awakeFromNib() {
        super.awakeFromNib()
        arrangeViews()
    }
}

// MARK: - Helpers
private extension CountryListTableViewCell {
    func arrangeViews() {
        roundCorners(with: 8, borderColor: .darkGray, borderWidth: 2.0)
    }
}

extension CountryListTableViewCell {
    func populateUI(countryName: String){
        countryNameLabel.text = countryName
    }
}
