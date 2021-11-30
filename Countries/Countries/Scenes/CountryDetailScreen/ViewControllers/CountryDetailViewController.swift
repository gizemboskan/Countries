//
//  CountryDetailViewController.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit
import RxSwift
import RxCocoa
import SVGKit

final class CountryDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: CountryDetailViewModelProtocol?
    
    @IBOutlet weak var countryDetailView: UIView!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryDetailButton: UIButton!
    private var favButton: UIBarButtonItem?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else { return }
        observeDataSource()
        viewModel.getCountryDetail()
        favButton = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self,
                                    action: #selector(favButtonPressed))
        navigationItem.rightBarButtonItem = favButton
        self.tabBarController?.tabBar.isHidden = true
        favButton?.tintColor = viewModel.isFav ? .black : .darkGray.withAlphaComponent(0.3)
    }
    
    @objc func favButtonPressed() {
        guard let viewModel = viewModel else { return }
        favButton?.tintColor = !viewModel.isFav ? .black : .darkGray.withAlphaComponent(0.3)
        viewModel.changeFavoriteCountry()
    }
}

// MARK: - Observe Data Source
extension CountryDetailViewController {
    private func observeDataSource(){
        guard let viewModel = viewModel else { return }
        
        viewModel.countryDetailDatasource
            .subscribe(onNext: { [weak self] data in
                guard let self = self,
                      let countryDetail = data else { return }
                self.observeUI(with: countryDetail)
            }).disposed(by: bag)
        
        viewModel.isLoading.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.startLoading()
                } else {
                    self.stopLoading()
                }
            })
            .disposed(by: bag)
        
        viewModel.onError.asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] onError in
                guard let self = self else { return }
                if onError {
                    self.showAlertController()
                }
            }).disposed(by: bag)
        
        countryDetailButton.rx.tap
            .subscribe(onNext: { data in
                let countryDetail = viewModel.countryDetailDatasource.value?.data
                if let countryDetailURL = URL(string: "https://www.wikidata.org/wiki/\(countryDetail?.wikiDataID ?? "")"),
                   UIApplication.shared.canOpenURL(countryDetailURL) {
                    UIApplication.shared.open(countryDetailURL)
                }
            })
            .disposed(by: bag)
    }
    
    private func observeUI(with countryDetail: CountryDetail?) {
        guard let viewModel = viewModel else { return }
        let countryDetail = viewModel.countryDetailDatasource.value?.data
        let countryCode = countryDetail?.code
        let countryImage = countryDetail?.flagImageURI
        self.title = countryDetail?.name
        self.populateUI(countryImageViewURL: countryImage.orEmpty, countryCode: countryCode.orEmpty)
    }
    
    private func populateUI(countryImageViewURL: String?, countryCode: String) {
        if let countryImageURL = countryImageViewURL,
           let url = URL(string: countryImageURL) {
            countryImageView.image = SVGKImage(contentsOf: url).uiImage
        }
        countryCodeLabel.text = countryCode
    }
}
