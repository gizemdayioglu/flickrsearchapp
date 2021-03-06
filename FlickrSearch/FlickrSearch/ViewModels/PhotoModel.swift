//
//  ImageModel.swift
//  FlickrSearch
//
//  Created by Gizem Gulsen on 6/21/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import UIKit

struct PhotoModel {

    let imageURL: String
    private let photo: FlickrPhoto
    init(withPhotos photo: FlickrPhoto) {
        imageURL = photo.imageURL
        self.photo = photo
    }
}
