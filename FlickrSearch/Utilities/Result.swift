//
//  Result.swift
//  FlickrSearch
//
//  Created by Gizem Gulsen on 6/21/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import UIKit

enum Result <T> {
    case success(T)
    case failure(String)
    case error(String)
}
