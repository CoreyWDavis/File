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
    
    @IBAction func saveTapped(_ sender: Any) {
        textToSave.endEditing(true)     // Hide keyboard
        
        // Get text
        guard let text = textToSave.text else { return }
        
        // Create a sample data object from the input text
        let sampleData = SampleData(text: text)
        
        // Write the sample object data
        do {
            let url = try sampleData.write(to: fileURLComponents)
            fileName.text = url.absoluteString
        } catch {
            showError(error)
        }
    }
    
    @IBAction func readTapped(_ sender: Any) {
        do {
            let sampleData = try SampleData.read(SampleData.self, from: fileURLComponents)
            textRead.text = sampleData.text
        } catch {
            showError(error)
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        do {
            guard try SampleData.delete(fileURLComponents) else {
                showAlert(withTitle: "File Does Not Exist",
                          andMessage: "Could not delete \(fileURLComponents.fileName + "." + fileURLComponents.fileExtension!) because it does not eixst.")
                return
            }
            textRead.text = nil
            fileName.text = fileURLComponents.fileName + "." + fileURLComponents.fileExtension! + " has been deleted"
            
            // Note: I do not advocate force-unwrapping, but in this case we will consider it safe because we know fileExtension has been set.
            
        } catch {
            showError(error)
        }
    }
    
    // The file components that will be used when reading & writing the file
    let fileURLComponents = FileURLComponents(fileName: "sample",
                                              fileExtension: "json",
                                              directoryName: nil,
                                              directoryPath: .documentDirectory)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func showError(_ error: Error) {
        showAlert(withTitle: "Error", andMessage: error.localizedDescription)
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
