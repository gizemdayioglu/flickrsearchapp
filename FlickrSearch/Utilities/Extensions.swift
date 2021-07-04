//
//  Extensions.swift
//  FlickrSearch
//
//  Created by Gizem Gulsen on 6/23/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import Foundation

extension String {
    func isNullOrEmpty() -> Bool {
         let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmed.isEmpty {
            return true
        }else {
            return false
        }
    }
}
