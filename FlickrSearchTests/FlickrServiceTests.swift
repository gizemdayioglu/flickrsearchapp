//
//  FlickrServiceTests.swift
//  FlickrSearchTests
//
//  Created by Gizem Gulsen on 6/22/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import XCTest

class FlickrServiceTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testValidatePhotoImageURL() {

        let expct = expectation(description: "Returns all fields to create valid image url")

        ServiceManager().request("kittens", pageNo: 1) { (result) in

            switch result {
            case .success(let results):

                guard let photosCount = results?.photo.count else {
                    XCTFail("No photos")
                    return
                }

                if photosCount > 0 {
                    XCTAssert(true, "Photos returned")

                    // Pick first photo to test image url
                    let photo = results?.photo.first

                    if photo?.server == nil {
                        XCTFail("No Server Id")
                    }

                    if photo?.id == nil {
                        XCTFail("No Id")
                    }

                    if photo?.secret == nil {
                        XCTFail("No Secret")
                    }

                    XCTAssert(true, "Success")
                    expct.fulfill()
                }
            case .failure(let message):
                XCTFail(message)
            case .error(let error):
                XCTFail(error)
            }
        }

        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }

    func testValidSearchText() {
        ServiceManager().request("dogs", pageNo: 1) { (result) in
            switch result {
            case .success(let results):
                if results != nil {
                    XCTAssert(true, "Success")
                } else {
                    XCTFail("No results")
                }
            case .failure(let message):
                XCTFail(message)
            case .error(let error):
                XCTFail(error)
            }
        }
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }

    func testSearchInvalidText() {
        let expct = expectation(description: "Error message")

        ServiceManager().request("", pageNo: 1) { (result) in
            switch result {
            case .success( _):
                XCTFail("No result")
            case .failure( _):
                XCTAssert(true, "Success")
                expct.fulfill()
            case .error( _):
                XCTAssert(true, "Success")
                expct.fulfill()
            }
        }

        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
    }
}
