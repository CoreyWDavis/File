//
//  File.swift
//  File
//
//  Created by Corey Davis on 10/6/18.
//  Copyright © 2018 Corey Davis. All rights reserved.
//

import Foundation

/// File name components are used to build the URL for a file's location.
/// - Parameters:
///    - fileName: The file name.
///    - fileExtension: An optional file extension (ex: "txt" for .txt).
///    - directoryName: An optional directory name. If the directory does not exist it will be created.
///    - directoryPath: The directory path were the optional directory name and file will be created (ex: FileManager.SearchPathDirectory.documentsDirectory).
public struct FileNameComponents {
    var fileName: String
    var fileExtension: String?
    var directoryName: String?
    var directoryPath: FileManager.SearchPathDirectory
}

/// When an object conforms to the FileWritable protocol, it is signaling that the object is capable of saving itself to a file.
public protocol FileWritable {
    func write(to fileNameParameters: FileNameComponents) throws -> URL
}

/// When an object conforms to the FileReadable protocol, it is signaling that the object is capable of creating itself from a file's contents.
public protocol FileReadable {
    static func read(from fileNameParameters: FileNameComponents) throws -> Self
}

/// When an object conforms to Fileable it will conform to both FileWritable and FileReadable.
public typealias Fileable = FileWritable & FileReadable

public enum FileError: Error {
    case unableToCreateDirectory(directory: String, reason: String)
}

/// The File class can be used by an object conforming to FileWriteable and/or FileReadable to handle read/write operations. This class should not be used to instantiate an object as as all functions are static.
public class File {
    
    /// A static function that will handle writing data to a file.
    /// - Parameters:
    ///    - data: The data to be written.
    ///    - to: The components that will make up the destination file URL.
    /// - Returns: The URL to the file.
    public static func write(_ data: Data, to fileNameComponents: FileNameComponents) throws -> URL {
        do {
            // Get the file destination url
            let destinationURL = try File.fileURL(using: fileNameComponents)
            
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
    public static func read(from fileNameComponents: FileNameComponents) throws -> Data {
        do {
            // Get the file source url
            let sourceURL = try File.fileURL(using: fileNameComponents)
            
            // Read the data from the file
            return try Data(contentsOf: sourceURL)
        } catch {
            throw error
        }
    }
    
    /// Constructs the file URL from the file components.
    /// - Parameters:
    ///    - using: The file components to be used when constructing the file URL.
    /// - Returns: The file URL.
    private static func fileURL(using fileNameComponents: FileNameComponents) throws -> URL {
        do {
            // Get the destination directory url
            let dirURL = try File.directoryURL(for: fileNameComponents.directoryName, at: fileNameComponents.directoryPath)
            
            // Create the file url
            var fileURL: URL
            if let fileExtension = fileNameComponents.fileExtension {
                // Add the file extension to the url
                fileURL = URL(fileURLWithPath: fileNameComponents.fileName, relativeTo: dirURL).appendingPathExtension(fileExtension)
            } else {
                fileURL = URL(fileURLWithPath: fileNameComponents.fileName, relativeTo: dirURL)
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
