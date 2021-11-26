//
//  FirstBarItemViewController.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit

final class FirstBarItemViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CountryListViewController")
        
        setViewControllers([vc], animated: false)
    }
}
