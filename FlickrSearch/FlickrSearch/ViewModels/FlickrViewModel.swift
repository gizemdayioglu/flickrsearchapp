//
//  FlickrViewModel.swift
//  FlickrSearch
//
//  Created by Gizem Gulsen on 6/21/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import UIKit

class FlickrViewModel: NSObject {

    private(set) var photoArray = [FlickrPhoto]()
    private var searchText = ""
    private var pageNo = 1
    private var totalPageNo = 1
    var showAlert: ((String) -> Void)?
    var dataUpdated: (() -> Void)?
    func searchPhotos(text: String, completion:@escaping () -> Void) {
        searchText = text
        photoArray.removeAll()
        fetchResults(completion: completion)
    }
    private func fetchResults(completion:@escaping () -> Void) {
        ServiceManager().request(searchText, pageNo: pageNo) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let results):
                    if let result = results {
                        self.totalPageNo = result.pages
                        self.photoArray.append(contentsOf: result.photo)
                        self.dataUpdated?()
                    }
                    completion()
                case .failure(let message):
                    self.showAlert?(message)
                    completion()
                case .error(let error):
                    if self.pageNo > 1 {
                        self.showAlert?(error)
                    }
                    completion()
                }
            }
        }
    }
    func fetchNextPhotos(completion:@escaping () -> Void) {
        if pageNo < totalPageNo {
            pageNo += 1
            fetchResults {
                completion()
            }
        } else {
            completion()
        }
    }
}
