//
//  CacheManager.swift
//  FlickrSearch
//
//  Created by Gizem Gulsen on 7/4/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import UIKit

class DataCache: NSObject {

    static let shared = DataCache()

    private(set) var imageCache: NSCache<AnyObject, AnyObject> = NSCache()

    func getCacheImage(key: String) -> UIImage? {
        if (self.imageCache.object(forKey: key as AnyObject) != nil) {
            return self.imageCache.object(forKey: key as AnyObject) as? UIImage
        } else {
            return nil
        }
    }

    func setCacheImage(key: String, image: UIImage) {
        self.imageCache.setObject(image, forKey: key as AnyObject)
    }

}
