//
//  FilterViewController.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/27/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit
import CoreData

class FilterViewController: UIViewController, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate {
    
    // -------------------------------------------------------------------------
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var filterNameTextField: UITextField!
    @IBOutlet weak var filterCategoryTextField: UITextField!
    @IBOutlet weak var minRatingLabel: UILabel!
    @IBOutlet weak var maxRatingLabel: UILabel!
    @IBOutlet weak var minRatingStepper: UIStepper!
    @IBOutlet weak var maxRatingStepper: UIStepper!
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumsButton: UIBarButtonItem!
    
//    let homeViewController = HomeViewController()
    var dataController = DataController.shared
    var minRating = 0.0
    var maxRating = 5.0
    
    // -------------------------------------------------------------------------
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveFilter))
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        filterNameTextField.delegate = self
        filterCategoryTextField.delegate = self
        applyRoundStylingFor(filterImageView)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ImagePicker Setup
    
    func pickImageFrom(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.barTintColor = .foodletteBlue
        imagePicker.navigationBar.tintColor = .white
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI Functionality
    
    @IBAction func minRatingStepperTapped(_ sender: Any) {
        minRating = minRatingStepper.value
        minRatingLabel.text = String(minRating)
    }
    
    @IBAction func maxRatingStepperTapped(_ sender: Any) {
        maxRating = maxRatingStepper.value
        maxRatingLabel.text = String(maxRating)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickImageFrom(sourceType: .camera)
    }
    
    @IBAction func pickImageFromAlbums(_ sender: Any) {
        pickImageFrom(sourceType: .photoLibrary)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Saving Filter to Core Data
    
    @objc func handleSaveFilter() {
        if filterNameTextField.text == "" {
            showAlert(message: "Enter a name for your filter")
        } else if minRating > maxRating {
            showAlert(message: "The minimum rating cannot exceed the maximum rating")
        } else if filterImageView.image == nil || filterImageView.image == UIImage(named: "no-image-icon") {
            showAlert(message: "Select an image for your filter")
        } else {
            saveFilterData()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func saveFilterData() {
        let filter = Filter(context: dataController.viewContext)
        filter.name = filterNameTextField.text
        let category = filterNameTextField.text?.replacingOccurrences(of: " ", with: "")
        filter.category = category
        filter.minRating = minRating
        filter.maxRating = maxRating
        if let filterImage = filterImageView.image {
            let imageData = filterImage.jpegData(compressionQuality: 0.8)
            filter.image = imageData
        }
        dataController.saveViewContext()
    }
}

// -----------------------------------------------------------------------------
// MARK: - TextField Delegate

extension FilterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// -----------------------------------------------------------------------------
// MARK: - ImagePicker Delegate

extension FilterViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            filterImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
