//
//  UIViewController+Extensions.swift
//  Countries
//
//  Created by Gizem Boskan on 26.11.2021.
//

import UIKit

extension UIViewController {
    
    /// Warnings
    func showAlertController(message: String = "Something went wrong!", title: String = "Error!"){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(ac, animated: true)
    }
    
    private static let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func startLoading() {
        
        DispatchQueue.main.async {
            let activityIndicator = UIViewController.activityIndicator
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.large
            activityIndicator.color = .black
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.widthAnchor.constraint(equalToConstant: 80),
                activityIndicator.heightAnchor.constraint(equalToConstant: 80),
                activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
            ])
            self.view.isUserInteractionEnabled = false
            activityIndicator.startAnimating()
        }
    }
    
    func stopLoading() {
        let activityIndicator = UIViewController.activityIndicator
        DispatchQueue.main.async {
            self.view.isUserInteractionEnabled = true
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
