//
//  File.swift
//  File
//
//  Created by Corey Davis on 10/6/18.
//

/*
 Copyright 2018 Corey Davis. All rights reserved. License under the MIT license:
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
*/

import Foundation

/// File name components are used to build the URL for a file's location.
/// - Parameters:
///    - fileName: The file name.
///    - fileExtension: An optional file extension (ex: "txt" for .txt).
///    - directoryName: An optional directory name. If the directory does not exist it will be created.
///    - directoryPath: The directory path were the optional directory name and file will be created (ex: FileManager.SearchPathDirectory.documentsDirectory).
public struct FileURLComponents {
    var fileName: String
    var fileExtension: String?
    var directoryName: String?
    var directoryPath: FileManager.SearchPathDirectory
}

/// When an object conforms to the FileWritable protocol, it is signaling that the object is capable of saving itself to a file.
public protocol FileWritable {
    func write(to fileURLComponents: FileURLComponents) throws -> URL
}

/// When an object conforms to the FileReadable protocol, it is signaling that the object is capable of creating itself from a file's contents.
public protocol FileReadable {
    static func read<T: Decodable>(_ type: T.Type, from fileURLComponents: FileURLComponents) throws -> T
}

public protocol FileDeletable {
    static func delete(_ fileURLComponents: FileURLComponents) throws -> Bool
}

/// When an object conforms to Fileable it will conform to FileWritable, FileReadable, and FileDeletable.
public typealias Fileable = FileWritable & FileReadable & FileDeletable

public enum FileError: Error {
    case unableToCreateDirectory(directory: String, reason: String)
}

/// The File class can be used by an object conforming to FileWriteable and/or FileReadable to handle read/write operations. This class should not be used to instantiate an object as as all functions are static.
public class File: NSObject {
    
    /// A static function that will handle writing data to a file.
    /// - Parameters:
    ///    - data: The data to be written.
    ///    - to: The components that will make up the destination file URL.
    /// - Returns: The URL to the file.
    public static func write(_ data: Data, to fileURLComponents: FileURLComponents) throws -> URL {
        do {
            // Get the file destination url
            let destinationURL = try File.fileURL(using: fileURLComponents)
            
            // Write the data to the file
            try data.write(to: destinationURL)
            return destinationURL
        } catch {
            throw error
        }
    }
    
    /// A static function that will handle reading data from a file.
    /// - Parameters:
    ///    - from: The components that will make up the source file URL.
    /// - Returns: The file data.
    public static func read(from fileURLComponents: FileURLComponents) throws -> Data {
        do {
            // Get the file source url
            let sourceURL = try File.fileURL(using: fileURLComponents)
            
            // Read the data from the file
            return try Data(contentsOf: sourceURL)
        } catch {
            throw error
        }
    }
    
    /// A static function that will handle deleting a file.
    /// - Parameters:
    ///    - from: The components that will make up the source file URL.
    public static func delete(_ fileURLComponents: FileURLComponents) throws -> Bool {
        do {
            // Get the file source url
            let sourceURL = try File.fileURL(using: fileURLComponents)
            
            // Check for the file's existence
            guard try File.exists(fileURLComponents) else {
                return false
            }
                
            // Delete the file at the URL
            try FileManager.default.removeItem(at: sourceURL)
            return true

        } catch {
            throw error
        }
    }
    
    /// A static function that will look for the existence of a file.
    /// - Parameters:
    ///    - from: The components that will make up the source file URL.
    /// - Returns: Returns `true` is the file exists otherwise returns `false`.
    public static func exists(_ fileURLComponents: FileURLComponents) throws -> Bool {
        do {
            // Get the file source url
            let sourceURL = try File.fileURL(using: fileURLComponents)
            
            // Check for the file's existence
            if FileManager.default.fileExists(atPath: sourceURL.path) {
                return true
            } else {
                return false
            }
        } catch {
            throw error
        }
    }
    
    /// Constructs the file URL from the file components.
    /// - Parameters:
    ///    - using: The file components to be used when constructing the file URL.
    /// - Returns: The file URL.
    private static func fileURL(using fileURLComponents: FileURLComponents) throws -> URL {
        do {
            // Get the destination directory url
            let dirURL = try File.directoryURL(for: fileURLComponents.directoryName, at: fileURLComponents.directoryPath)
            
            // Create the file url
            var fileURL: URL
            if let fileExtension = fileURLComponents.fileExtension {
                // Add the file extension to the url
                fileURL = URL(fileURLWithPath: fileURLComponents.fileName, relativeTo: dirURL).appendingPathExtension(fileExtension)
            } else {
                fileURL = URL(fileURLWithPath: fileURLComponents.fileName, relativeTo: dirURL)
            }
            return fileURL
        } catch {
            throw error
        }
    }
    
    /// Constructs a directory URL from the given directory path and optional name.
    /// - Parameters:
    ///    - for: An optional directory name.
    ///    - at: The base directory path.
    /// - Returns: The directory URL.
    private static func directoryURL(for directoryName: String?, at directoryPath: FileManager.SearchPathDirectory) throws -> URL {
        // Get base directory path url
        var destinationDirectoryURL = FileManager.default.urls(for: directoryPath, in: .userDomainMask)[0]
        
        // Append a new directory name if applicable
        if let directoryName = directoryName {
            destinationDirectoryURL = destinationDirectoryURL.appendingPathComponent(directoryName, isDirectory: true)
        }
        
        // Create the directory
        do {
            try FileManager.default.createDirectory(at: destinationDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            return destinationDirectoryURL
        } catch {
            throw FileError.unableToCreateDirectory(directory: destinationDirectoryURL.absoluteString, reason: error.localizedDescription)
        }
    }
}

//extension File: FileManagerDelegate {
//    public func fileManager(_ fileManager: FileManager, shouldRemoveItemAt URL: URL) -> Bool {
//        // An assumption is being made here that this file should be deleted
//        return true
//    }
//}
