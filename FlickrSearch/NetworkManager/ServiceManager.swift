//
//  NetworkManager.swift
//  FlickrSearch
//
//  Created by Gizem Gulsen on 6/21/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import Reachability

class ServiceManager: NSObject {
    static let shared = ServiceManager()
    static let errorMessage = "Something went wrong, Please try again later"
    static let noInternetConnection = "Please check your Internet connection and try again."
    static let okResult = "OK"
    func request(_ searchText: String, pageNo: Int, completion: @escaping (Result<FlickrPhotos?>) -> Void) {
        let urlString = String(format: FlickrConstants.searchURL, searchText, pageNo)
        AF.request(urlString).responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                guard let resultVal = responseData.data else {
                    return
                }
                if let model = self.response(resultVal) {
                    if let stat = model.stat, stat.uppercased().contains(ServiceManager.okResult) {
                        return completion(.success(model.photos))
                    } else {
                        return completion(.failure(ServiceManager.errorMessage))
                    }
                } else {
                    return completion(.failure(ServiceManager.errorMessage))
                }
            case let .failure(error):
                print("Json could not be created.", error)
            }
        }
    }
    func response(_ data: Data) -> FlickrResults? {
        do {
            let responseModel = try JSONDecoder().decode(FlickrResults.self, from: data)
            return responseModel
        } catch {
            print("Data parsing error: \(error.localizedDescription)")
            return nil
        }
    }
    func retrieveImage(_ urlString: String, completion: @escaping (Result<UIImage>) -> Void) {
        AF.request(urlString).responseImage { response in
            if case .success(let image) = response.result {
                print("image downloaded: \(image)")
                return completion(.success(image))
            }
        }
    }
}
