//
//  SearchData+CoreDataProperties.swift
//  
//
//  Created by Gizem Gulsen on 7/4/21.
//
//

import Foundation
import CoreData

extension SearchData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchData> {
        return NSFetchRequest<SearchData>(entityName: "SearchData")
    }

    @NSManaged public var searchedText: String?

}
