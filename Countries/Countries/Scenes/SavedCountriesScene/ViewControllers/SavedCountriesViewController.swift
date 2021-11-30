//
//  SavedCountriesViewController.swift
//  Countries
//
//  Created by Gizem Boskan on 27.11.2021.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

final class SavedCountriesViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: SavedCountriesViewModelProtocol?
    @IBOutlet weak var savedCountriesTableView: UITableView!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeViews()
        observeDataSource()
        guard let viewModel = viewModel else { return }
        viewModel.getSavedCountryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

//  MARK: - Arrange Views
extension SavedCountriesViewController {
    func arrangeViews() {
        title = "Saved Countries"
        self.tabBarController?.tabBar.isHidden = false
        let nibCell = UINib(nibName: "CountryTableViewCell", bundle: nil)
        savedCountriesTableView.register(nibCell, forCellReuseIdentifier: "CountryTableViewCell")
        savedCountriesTableView.delegate = self
        savedCountriesTableView.dataSource = self
    }
}

// MARK: - Observe Data Source
extension SavedCountriesViewController {
    private func observeDataSource(){
        guard let viewModel = viewModel else { return }
        
        viewModel.savedCountryListDatasource.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.savedCountriesTableView.reloadData()
        }).disposed(by: bag)
        
        viewModel.navigateToDetailReady
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self] navigationItem in
                guard let self = self else { return }
                let countryDetailViewController = CountryDetailBuilder.make(repository: navigationItem.repository,
                                                                            code: navigationItem.code,
                                                                            isFav: navigationItem.isFav)
                self.navigationController?.pushViewController(countryDetailViewController, animated: true)
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
    }
}

// MARK: - UITableViewDataSource
extension SavedCountriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return .zero }
        
        return viewModel.savedCountryListDatasource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = savedCountriesTableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell",
                                                               for: indexPath) as! CountryTableViewCell
        let country = viewModel.savedCountryListDatasource.value[indexPath.row]
        cell.favButton.imageView?.alpha = 1.0
        let countryName = country.name
        cell.viewModel = viewModel.getCellViewModels(indexpath: indexPath)
        cell.populateUI(countryName: countryName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let country = viewModel.savedCountryListDatasource.value[indexPath.row]
        let countryCode = country.code
        let isFav = country.isFav
        viewModel.navigateToDetail(code: countryCode, isFav: isFav)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
