//
//  SimpleProjectTests.swift
//  SimpleProjectTests
//
//  Created by Arnold Noronha on 1/5/24.
//

import XCTest
import SnapshotTesting
import SwiftUI

@testable import SimpleProject

final class SimpleProjectTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        let view = ContentView()
        assertSnapshot(matching: view, as: .image)
    }

    func testEditBoxWithButton() throws {
        let view = VStack {
            TextField("Enter text", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Submit") {
                // Button action
            }
            .padding()
        }
        assertSnapshot(matching: view, as: .image(on: .iPhone13))
    }



    func testDataSnapshot() throws {
        let data = "foobar"
        assertSnapshot(matching: data, as: .dump)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
    }

}
