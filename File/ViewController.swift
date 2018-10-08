//
//  ViewController.swift
//  File
//
//  Created by Corey Davis on 10/6/18.
//  Copyright © 2018 Corey Davis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textToSave: UITextField!
    @IBOutlet weak var textRead: UILabel!
    @IBOutlet weak var fileName: UILabel!
    
    @IBAction func save(_ sender: Any) {
        textToSave.endEditing(true)     // Hide keyboard
        
        // Get text
        guard let text = textToSave.text else { return }
        
        // Create a sample data object from the input text
        let sampleData = SampleData(text: text)
        
        // Write the sample object data
        do {
            let url = try sampleData.write(to: fileComponents)
            fileName.text = url.absoluteString
        } catch {
            showAlert(withTitle: "Error", andMessage: error.localizedDescription)
        }
    }
    
    @IBAction func read(_ sender: Any) {
        do {
            guard let sampleData = try SampleData.read(from: fileComponents) as? SampleData else {
                return
            }
            textRead.text = sampleData.text
        } catch {
            showAlert(withTitle: "Error", andMessage: error.localizedDescription)
        }
    }
    
    // The file components that will be used when reading & writing the file
    let fileComponents = FileURLComponents(fileName: "sample",
                                            fileExtension: "json",
                                            directoryName: nil,
                                            directoryPath: .documentDirectory)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController {
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
