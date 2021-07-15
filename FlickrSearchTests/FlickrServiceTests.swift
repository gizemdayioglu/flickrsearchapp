//
//  FlickrServiceTests.swift
//  FlickrSearchTests
//
//  Created by Gizem Gulsen on 6/22/21.
//  Copyright © 2021 Gizem Dayioglu. All rights reserved.
//

import XCTest
@testable import FlickrSearch

class FlickrServiceTests: XCTestCase {

    var serviceManager: ServiceManager?
    override func setUp() {
        super.setUp()
        serviceManager = ServiceManager()
    }

    override func tearDown() {
        serviceManager = nil
        super.tearDown()
    }
    func testValidatePhotoImageURL() {
        let srvcManager = self.serviceManager!
        let expct = expectation(description: "Returns all fields to create valid image url")

        srvcManager.request("kittens", pageNo: 1) { (result) in

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
        let srvcManager = self.serviceManager!
        let expct = expectation(description: "Returns json response")

        srvcManager.request("dogs", pageNo: 1) { (result) in
            switch result {
            case .success(let results):
                if results != nil {
                    XCTAssert(true, "Success")
                    expct.fulfill()
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
        let srvcManager = self.serviceManager!
        let expct = expectation(description: "Error message")

        srvcManager.request("", pageNo: 1) { (result) in
            switch result {
            case .success:
                XCTFail("No result")
            case .failure:
                XCTAssert(true, "Success")
                expct.fulfill()
            case .error:
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
