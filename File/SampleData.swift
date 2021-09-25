//
//  SampleData.swift
//  File
//
//  Created by Corey Davis on 10/6/18.
//  Copyright © 2018 Corey Davis. All rights reserved.
//

import Foundation

struct SampleData: Codable, Fileable {
    let text: String
}

// The sample object will conform to equatable to prove that the file written to and read from are equal, but this is not required of your objects to use File.
extension SampleData: Equatable {
    static func == (lhs: SampleData, rhs: SampleData) -> Bool {
        return lhs.text == rhs.text
    }
}
