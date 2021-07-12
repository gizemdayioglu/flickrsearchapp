//
//  CoreDataViewModel.swift
//  FlickrSearch
//
//  Created by Gizem Gulsen on 7/11/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import UIKit
import CoreData

class CoreDataViewModel: NSObject {

    var searchTexts = [String]()

    func getData(completion:@escaping () -> Void) {
        // swiftlint:disable force_cast
        getCoreData(completion: completion)
    }
    func setData(searchText: String) {
        setCoreData(text: searchText)
    }
    private func getCoreData(completion:@escaping () -> Void) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // swiftlint:disable force_cast
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SearchData")
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let searchedText = result as! SearchData
                if !(searchedText.searchedText?.isNullOrEmpty())! {
                    searchTexts.append(searchedText.searchedText!)
                }
            }
            completion()
        } catch {
            print("Fetch Failed")
        }
    }

    private func setCoreData(text: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "SearchData", in: context)
        let searchData = NSManagedObject(entity: entity!, insertInto: context)
        searchData.setValue("\(text)", forKeyPath: "searchedText")
        do {
            try context.save()
        } catch {
            print("context save error")
        }
    }

}
