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
    
    @IBOutlet weak var countryDetailView: CountryDetailView!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryDetailButton: UIButton!
    @IBOutlet weak var favButton: UIBarButtonItem!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        observeDataSource()
        self.tabBarController?.tabBar.isHidden = true
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
        
        // TODO: IMPLEMENT PROPER DATASTRUCTURE!
//        favButton.rx.tap
//            .subscribe(onNext: { data in
//                if datum.isFav {
//                    cell.favButton.imageView?.alpha = 0.3
//                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//                    let context = appDelegate.persistentContainer.viewContext
//                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"SavedCountries")
//
//                    fetchRequest.predicate = NSPredicate(format: "savedCountryCode = %@", "\(datum.code)")
//                    do
//                    {
//                        let fetchedResults =  try context.fetch(fetchRequest) as? [NSManagedObject]
//
//                        for entity in fetchedResults! {
//
//                            context.delete(entity)
//                        }
//                        try context.save()
//                    }
//                    catch _ {
//                        print("Could not be deleted!")
//                    }
//                } else {
//                    favButton.imageView?.alpha = 1.0
//                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//                    let context = appDelegate.persistentContainer.viewContext
//                    let newCountry = NSEntityDescription.insertNewObject(forEntityName: "SavedCountries", into: context)
//
//                    newCountry.setValue(datum.code, forKey: "savedCountryCode")
//
//                    do {
//                        try context.save()
//                    } catch  {
//                        print("Could not be saved!")
//                    }
//                }
//                datum.isFav.toggle()
//            })
            //.disposed(by: bag)
        
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

    func observeUI(with countryDetails: CountryDetails?) {
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
