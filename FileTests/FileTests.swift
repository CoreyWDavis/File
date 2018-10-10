//
//  FileTests.swift
//  FileTests
//
//  Created by Corey Davis on 10/9/18.
//  Copyright © 2018 Corey Davis. All rights reserved.
//

import XCTest

class FileTests: XCTestCase {
    
    private var fileURLComponents = FileURLComponents(fileName: "test", fileExtension: "json", directoryName: nil, directoryPath: .documentDirectory)
    private var testString = "Hello World!"

    override func setUp() {
    }

    override func tearDown() {
        // Nothing to do here.
    }

    func testFileWriteThenRead() {
        guard let writeData = testString.data(using: .utf8) else {
            XCTFail("Unable to create data from test string")
            return
        }
        do {
            _ = try File.write(writeData, to: fileURLComponents)
            do {
                let readData = try File.read(from: fileURLComponents)
                XCTAssert(writeData == readData, "The data written is not the same as the data read")
            } catch {
                XCTFail("Failed to read data: \(error.localizedDescription)")
            }
        } catch {
            XCTFail("Failed to write data: \(error.localizedDescription)")
        }
    }
}
