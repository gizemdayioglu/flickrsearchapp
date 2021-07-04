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
                self.imageView.loadImage(urlString: model.imageURL)
            }
        }
    }
}
