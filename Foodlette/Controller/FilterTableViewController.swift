//
//  FilterTableViewController.swift
//  Foodlette
//
//  Created by Justin on 9/18/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit
import CoreData

class FilterTableViewController: UITableViewController {
    
    // -------------------------------------------------------------------------
    // MARK: - Outlets and Variables

    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterNameTextField: UITextField!
    @IBOutlet weak var filterCategoryTextField: UITextField!
    @IBOutlet weak var filterNarrativeTextField: UITextField!
    @IBOutlet weak var filterMaxRatingLabel: UILabel!
    @IBOutlet weak var filterMinRatingLabel: UILabel!
    @IBOutlet weak var filterMaxRatingStepper: UIStepper!
    @IBOutlet weak var filterMinRatingStepper: UIStepper!
    
    var dataController = DataController.shared
    var maxRating = 5.0
    var minRating = 1.0
    
    // -------------------------------------------------------------------------
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Create Filter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSaveFilter))
        navigationItem.rightBarButtonItem?.tintColor = .black
        filterNameTextField.delegate = self
        filterCategoryTextField.delegate = self
        filterNarrativeTextField.delegate = self
        applyRoundStylingFor(filterImageView)
        setupImageView()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Life Cycle
    
    @IBAction func maxRatingStepperTapped(_ sender: Any) {
        maxRating = filterMaxRatingStepper.value
        filterMaxRatingLabel.text = String(maxRating)
    }
    
    @IBAction func minRatingStepperTapped(_ sender: Any) {
        minRating = filterMinRatingStepper.value
        filterMinRatingLabel.text = String(minRating)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI Functionality
    
    func setupImageView() {
        filterImageView.isUserInteractionEnabled = true
        filterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImage)))
    }
    
    @objc func handleSelectImage() {
        pickImageFrom()
    }
    
    func pickImageFrom() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.navigationBar.barTintColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        imagePickerController.navigationBar.isTranslucent = false
        imagePickerController.navigationBar.tintColor = .black
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
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
    
    // -------------------------------------------------------------------------
    // MARK: - Save Filter Details to CoreData
    
    func saveFilterData() {
        let filter = Filter(context: dataController.viewContext)
        filter.name = filterNameTextField.text
        let category = filterNameTextField.text?.replacingOccurrences(of: " ", with: "")
        filter.category = category
        filter.narrative = filterNarrativeTextField.text
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

extension FilterTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
