//
//  CountryListViewController.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

final class CountryListViewController: UIViewController {
    
    // MARK: - Properties
    private let bag = DisposeBag()
    var viewModel: CountryListViewModelProtocol?
    @IBOutlet weak var countryListTableView: MainScreenView!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        arrangeViews()
        observeDataSource()
        guard let viewModel = viewModel else { return }
        viewModel.getCountryList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

//  MARK: - Arrange Views
extension CountryListViewController {
    func arrangeViews() {
        title = "Countries"
        self.tabBarController?.tabBar.isHidden = false
        let nibCell = UINib(nibName: "CountryTableViewCell", bundle: nil)
        countryListTableView.register(nibCell, forCellReuseIdentifier: "CountryTableViewCell")
        countryListTableView.delegate = self
        countryListTableView.dataSource = self
    }
}

// MARK: - Observe Data Source
extension CountryListViewController {
    func observeDataSource(){
        guard let viewModel = viewModel else { return }
        
        viewModel.countryListDatasource.subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.countryListTableView.reloadData()
        }).disposed(by: bag)
        
        viewModel.navigateToDetailReady
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self] countryDetailViewModel in
                guard let self = self else { return }
                let countryDetailViewController = CountryDetailBuilder.make(with: countryDetailViewModel)
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
extension CountryListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return .zero }
        
        return viewModel.countryListDatasource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = countryListTableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell",
                                                            for: indexPath) as! CountryTableViewCell
        let country = viewModel.countryListDatasource.value[indexPath.row]
        if country.isFav {
            cell.favButton.imageView?.alpha = 1.0
        } else {
            cell.favButton.imageView?.alpha = 0.3
        }
        let countryName = country.name
        cell.viewModel = viewModel.getCellViewModels(indexpath: indexPath)
        cell.populateUI(countryName: countryName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let country = viewModel.countryListDatasource.value[indexPath.row]
        let countryCode = country.code
        viewModel.navigateToDetail(code: countryCode)
    }
}

// MARK: - UITableViewDelegate
extension CountryListViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        UITableView.automaticDimension
    //    }
}
