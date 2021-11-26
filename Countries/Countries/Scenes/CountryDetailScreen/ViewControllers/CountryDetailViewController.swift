//
//  CountryDetailViewController.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class CountryDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: CountryDetailViewModelProtocol?
    
    @IBOutlet weak var countryDetailView: CountryDetailView!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryDetailButton: UIButton!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        observeDataSource()
    }
    
}

// MARK: - Observe Data Source
extension CountryDetailViewController {
    func observeDataSource(){
        guard let viewModel = viewModel else { return }
        
        viewModel.countryCodeDatasource
            .subscribe(onNext: { [weak self] data in
                guard let self = self,
                      let countryCode = data else { return }
                self.viewModel?.getcountryDetails(countryCode: countryCode)
            }).disposed(by: bag)
        
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
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                let countryDetail = viewModel.countryDetailDatasource.value?.data
                if let countryDetailURL = URL(string: "https://www.wikidata.org/wiki/\(countryDetail?.wikiDataID ?? "")"),
                   UIApplication.shared.canOpenURL(countryDetailURL) {
                    UIApplication.shared.open(countryDetailURL)
                }
            })
            .disposed(by: bag)
        
    }
    func observeUI(with countryDetails: CountryDetails?) {
        guard let viewModel = viewModel else { return }
        let countryDetail = viewModel.countryDetailDatasource.value?.data
        let countryCode = countryDetail?.code
        let countryImage = countryDetail?.flagImageURI
        self.title = countryDetail?.name
        self.populateUI(countryImageViewURL: countryImage.orEmpty, countryCode: countryCode.orEmpty)
    }
    private func populateUI(countryImageViewURL: String?, countryCode: String) {
        if let countryImageViewURL = countryImageViewURL {
            countryImageView.setImage(with: countryImageViewURL)
        }
        countryCodeLabel.text = countryCode
    }
    
}
