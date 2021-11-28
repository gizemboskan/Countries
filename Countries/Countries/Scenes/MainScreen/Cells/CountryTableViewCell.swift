//
//  CountryTableViewCell.swift
//  Countries
//
//  Created by Gizem Boskan on 28.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class CountryTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: CountryTableViewCellViewModelProtocol?
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var favButton: UIButton! {
        didSet {
            favButton.tintColor = .darkGray.withAlphaComponent(0.3)
        }
    }
    @IBOutlet weak var countryListCellView: UIView!
    
    // MARK: - Initilizations
    override func awakeFromNib() {
        super.awakeFromNib()
        arrangeViews()
    }
    @IBAction func favButtonPressed(_ sender: Any) {
        viewModel?.changeFavoriteCountry()
    }
}

// MARK: - Helpers
private extension CountryTableViewCell {
    func arrangeViews() {
        countryListCellView.roundCorners(with: 12, borderColor: .darkGray, borderWidth: 2.0)
    }
}

extension CountryTableViewCell {
    func populateUI(countryName: String){
        countryNameLabel.text = countryName
    }
}
