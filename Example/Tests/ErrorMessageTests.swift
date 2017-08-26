//
//  ErrorMessageTests.swift
//  FeedCollectionViewController
//
//  Created by Oliver ONeill on 11/02/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import FBSnapshotTestCase
import ImageFeedCollectionViewController
@testable import FeedCollectionViewController_Example

class ErrorMessageTests: FBSnapshotTestCase {
    private var c: ErroringColorFeedViewController?
    
    override func setUp() {
        super.setUp()
        // recordMode = true
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: ColorCaptionFeedViewController.self))
        c = storyboard.instantiateViewController(withIdentifier: "ErroringColorFeedViewController") as? ErroringColorFeedViewController
        // we don't require a delay for the unit tests
        c?.loadingDelay = 0
        c?.imageDelay = 0
        UIApplication.shared.keyWindow!.rootViewController = c
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testErrorMessages() {
        ColorFeedViewController.length = -1
        testDisplay()
    }
    
    func testCustomErrorMessage() {
        ColorFeedViewController.length = -1
        c?.errorMessage = "Something went wrong. Please try again later."
        c?.refreshFeed()
        testDisplay()
    }
    
    func testHidingMessage() {
        ColorFeedViewController.length = -1
        c?.refreshFeed()
        let expect = expectation(description: "Wait for refresh to finish")
        // must wait for previous refresh to finish before reloading again
        DispatchQueue.main.async {
            ColorFeedViewController.length = 50
            self.c?.refreshFeed()
            // wait for images to load
            DispatchQueue.main.async {
                let view = self.c!.view
                self.FBSnapshotVerifyView(view!)
                self.FBSnapshotVerifyLayer(view!.layer)
                expect.fulfill()
            }
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testDisplay() {
        let expect = expectation(description: "Wait for data to load")
        // wait for main thread to display current content
        DispatchQueue.main.async {
            let view = self.c!.view
            self.FBSnapshotVerifyView(view!)
            self.FBSnapshotVerifyLayer(view!.layer)
            expect.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
}
