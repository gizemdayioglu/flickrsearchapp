//
//  Extensions.swift
//  FlickrSearch
//
//  Created by Gizem Gulsen on 6/23/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import UIKit

extension String {
    func isNullOrEmpty() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return true
        } else { return false }
    }
}
extension UIImageView {
    func loadImage(urlString: String) {
        image = nil

        if let imageFromCache = CacheManager.shared.getCacheImage(key: urlString) {
            image = imageFromCache
            return
        }
        ServiceManager.shared.retrieveImage(urlString) { (result) in
            switch result {
            case .success(let data):
                CacheManager.shared.setCacheImage(key: urlString, image: data)
                self.image = data
            case .failure:
                self.image = UIImage(named: "noImage")
            default:
                break
            }
        }
    }
}
