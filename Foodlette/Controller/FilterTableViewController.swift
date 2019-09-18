//
//  FilterTableViewController.swift
//  Foodlette
//
//  Created by Justin on 9/18/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterNameTextField: UITextField!
    @IBOutlet weak var filterCategoryTextField: UITextField!
    @IBOutlet weak var filterMaxRatingLabel: UILabel!
    @IBOutlet weak var filterMinRatingLabel: UILabel!
    @IBOutlet weak var filterMaxRatingStepper: UIStepper!
    @IBOutlet weak var filterMinRatingStepper: UIStepper!
    
    var dataController = DataController.shared
    var maxRating = 5.0
    var minRating = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveFilter))
        filterNameTextField.delegate = self
        filterCategoryTextField.delegate = self
        applyRoundStylingFor(filterImageView)
    }
    
    func pickImageFrom(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.navigationBar.isTranslucent = false
//        imagePicker.navigationBar.barTintColor = .foodletteBlue
        imagePicker.navigationBar.tintColor = .white
        imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = sourceType
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func maxRatingStepperTapped(_ sender: Any) {
        maxRating = filterMaxRatingStepper.value
        filterMaxRatingLabel.text = String(maxRating)
    }
    
    @IBAction func minRatingStepperTapped(_ sender: Any) {
        minRating = filterMinRatingStepper.value
        filterMinRatingLabel.text = String(minRating)
    }
    
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

extension FilterTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// -----------------------------------------------------------------------------
// MARK: - ImagePicker Delegate

extension FilterTableViewController: UIImagePickerControllerDelegate {
    
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
