#  File
A simple API to read, write, and delete files in Swift.

## Features
- Lightweight and easy to learn.
- Uses `do, try, catch` for intuitive error handling.
- Pure Swift implementation.

## Using File
In its most simplistic form, File can be used to simply write data to files and read it back again.

First, setup a file URL components property:

```swift
let fileURLComponents = FileURLComponents(fileName: "my-file-name",
                                       fileExtension: "json",
                                       directoryName: nil,
                                       directoryPath: .documentDirectory)
```

Then, once you have some data that is ready to be saved, pass it and the file URL components to File's `write` function:

```swift
do {
    _ = try File.write(data, to: fileURLComponents)
} catch {
    throw error
}
```

To read the file, use File's `read` function:

```swift
do {
    let data = try File.read(from: fileURLComponents)
} catch {
    throw error
}
```

To delete the file, use File's `delete` function:

```swift
do {
    _ = try File.delete(fileURLComponents)
} catch {
    throw error
}
```

## Using File with Custom Classes
To get the most out of File, use the `FileWritable`, `FileReadable`, and/or `FileDeletable` protocols in your custom classes.

```swift
extension YourClass: FileWritable {
    func write(to fileURLComponents: FileURLComponents) throws -> URL {
        // Encode the object to JSON data.
        let data = try JSONEncoder().encode(self)
        // Write the data to a file using the File class.
        return try File.write(data, to: fileURLComponents)
    }
}
```

```swift
extension YourClass: FileReadable {
    static func read<T: Decodable>(_ type: T.Type, from fileURLComponents: FileURLComponents) throws -> T {
        // Read the file data using the File class.
        let data = try File.read(from: fileURLComponents)
        // Decode the JSON data into an object.
        return try JSONDecoder().decode(type, from: data)
    }
}
```

```swift
extension YourClass: FileDeletable {
    static func delete(_fileURLComponents: FileURLComponents) throws -> Bool {
        // Delete the file at the file URL component's location
        return try File.delete(fileURLComponents)
    }
}
```

If your object will conform to `FileWritable`, `FileReadable`, and `FileDeleable` then you can use the typealias `Fileable`.

To see it in action, download the File Xcode project.

## How to Use File in Your Project
Until File is converted into a Cocoapod, simply drag the `File.swift` file into your Xcode project.

## To Do
Things I would like to get to sometime soon:

- [x] Deleting files
- [ ] Cocoapod support
- [ ] File renaming
- [ ] Folder navigation and file traversal
- [ ] Moving/copying files between folders

## Have Questions or Suggestions?
If you have a problem or question, please [open an issue](https://github.com/CoreyWDavis/File/issues). You can also contact me on Twitter [@CoreyDavis](https://twitter.com/coreydavis).
