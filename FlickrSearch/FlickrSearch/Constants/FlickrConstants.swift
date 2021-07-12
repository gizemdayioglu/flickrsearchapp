//
//  FlickrConstants.swift
//  FlickrSearch
//
//  Created by Gizem Gulsen on 6/21/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import UIKit

class FlickrConstants: NSObject {

    static let apiKey = "11c40ef31e4961acf4f98c8ff4e945d7"
    static let perPage = 50
    // swiftlint:disable line_length
    static let searchURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(FlickrConstants.apiKey)&format=json&nojsoncallback=1&safe_search=1&per_page=\(FlickrConstants.perPage)&text=%@&page=%ld"
    static let imageURL = "https://farm%d.staticflickr.com/%@/%@_%@_m.jpg"

    static let defaultColumnCount: CGFloat = 2.0
    static let searchTextCharCount = 1
    static let firstSearchText = "Kittens"
}
