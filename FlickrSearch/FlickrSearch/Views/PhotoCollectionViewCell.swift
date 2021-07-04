//
//  ImageCollectionViewCell.swift
//  FlickrSearch
//
//  Created by Gizem Gulsen on 6/21/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    static let nibName = "PhotoCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        imageView.image = nil
    }
    var model: PhotoModel? {
        didSet {
            if let model = model {
                imageView.image = UIImage(named: "placeholder")
                ServiceManager.shared.retrieveImage(model.imageURL) { (result) in
                    switch result {
                       case .success(let image):
                         self.imageView.image = image
                       default:
                         break
                  }
                    
               }
            }
        }
    }
}
