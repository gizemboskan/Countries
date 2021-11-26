//
//  SecondBarItemViewController.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit

final class SecondBarItemViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "CountryDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CountryDetailViewController")
        
        setViewControllers([vc], animated: false)
    }
}
