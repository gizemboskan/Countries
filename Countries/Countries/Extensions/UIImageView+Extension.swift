//
//  UIImageView+Extension.swift
//  Countries
//
//  Created by Gizem Boskan on 27.11.2021.
//

import Foundation
import UIKit
import Kingfisher

// MARK: - UIImageView Extension
extension UIImageView {
    func setImage(with url: String?, placeholder: UIImage? = nil, errorImage: UIImage? = nil) {
        guard let urlString = url else {return}
        guard let url = URL(string: urlString) else {return}
        self.kf.setImage(with: url, placeholder: placeholder, completionHandler:  { result in
            switch result {
            case .success(let value):
                self.image = value.image
                self.clipsToBounds = true
            case .failure(_):
                self.image = errorImage
            }
        })
    }
}
