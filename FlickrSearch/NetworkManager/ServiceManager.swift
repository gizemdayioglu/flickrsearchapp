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

enum APIError: String, Error {
    case noInternetConnection = "Please check your Internet connection and try again."
    case serverOverload = "Server is overloaded"
    case permissionDenied = "You don't have permission"
    case defaultError = "Something went wrong, Please try again later"
}

protocol ServiceManagerProtocol {
    func request(_ searchText: String, pageNo: Int, completion: @escaping (_ photos: Result<FlickrPhotos?>) -> Void )
}

class ServiceManager: ServiceManagerProtocol {
    static let shared = ServiceManager()
    static let okResult = "OK"
    func request(_ searchText: String, pageNo: Int, completion: @escaping (_ photos: Result<FlickrPhotos?>) -> Void ) {

        let urlString = String(format: FlickrConstants.searchURL, searchText, pageNo)

        guard URL.init(string: urlString) != nil else {
            return completion(.failure(APIError.defaultError.rawValue))
        }

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
                        return completion(.failure(APIError.defaultError.rawValue))
                    }
                } else {
                    return completion(.failure(APIError.defaultError.rawValue))
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
