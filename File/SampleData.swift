//
//  SampleData.swift
//  File
//
//  Created by Corey Davis on 10/6/18.
//  Copyright © 2018 Corey Davis. All rights reserved.
//

import Foundation

struct SampleData: Codable {
    let text: String
}

extension SampleData: Fileable {
    func write(to fileURLComponents: FileURLComponents) throws -> URL {
        // Encode the object to JSON data.
        let data = try JSONEncoder().encode(self)
        // Write the data to a file using the File class.
        return try File.write(data, to: fileURLComponents)
    }
    
    static func read<T: Decodable>(_ type: T.Type, from fileURLComponents: FileURLComponents) throws -> T {
        // Read the sample data from the file.
        let data = try File.read(from: fileURLComponents)
        // Decode the JSON data into an object.
        return try JSONDecoder().decode(type, from: data)
    }
}

// The sample object will conform to equatable to prove that the file written to and read from are equal, but this is not required of your objects to use File.
extension SampleData: Equatable {
    static func == (lhs: SampleData, rhs: SampleData) -> Bool {
        return lhs.text == rhs.text
    }
}
