//
//  HomeViewController.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/27/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class HomeViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // -------------------------------------------------------------------------
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var createFilterButton: UIBarButtonItem!
    @IBOutlet weak var typeFilterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var toolbar: UIToolbar!
    
    let font = UIFont(name: "Futura-Bold", size: 14.0)
    let locationManager = CLLocationManager()
    var dataController = DataController.shared
    var fetchedResultsController: NSFetchedResultsController<Filter>!
    var latitude = 0.0
    var longitude = 0.0
    var fetchedFilterArray: [Filter] = []
    var defaultFilterSelected: DefaultFilter?
    var createdFilterSelected: Filter?
//    var foodletteWinner: Business?
    
    // -------------------------------------------------------------------------
    // MARK: - Fetching Data
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Filter> = Filter.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            fetchedFilterArray = fetchedResultsController.fetchedObjects ?? []
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setupCollectionViewCells()
        typeFilterSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font ?? "Futura-Bold"], for: .normal)
        setupFetchedResultsController()
        updateEditButtonState()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        collectionView.reloadData()
        navigationItems(isEnabled: true)
        updateEditButtonState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI Functionality
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        collectionView.reloadData()
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        updateEditButtonState()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        if let selected = collectionView.indexPathsForSelectedItems {
            deleteSelectedFilter(at: selected)
        }
        toolbar.isHidden = true
        updateEditButtonState()
    }
    
    func deleteSelectedFilter(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let filterToDelete = fetchedFilterArray[indexPath.row]
            dataController.viewContext.delete(filterToDelete)
            dataController.saveViewContext()
            setupFetchedResultsController()
            collectionView.reloadData()
        }
    }
    
    func setupCollectionViewCells() {
        let space: CGFloat = 8.0
        let dimension: CGFloat = (view.frame.size.width - (3 * space)) / 2
        flowLayout.minimumInteritemSpacing = space
        flowLayout.sectionInset.left = space
        flowLayout.sectionInset.right = space
        flowLayout.sectionInset.top = space
        flowLayout.sectionInset.bottom = space
        flowLayout.itemSize = CGSize(width: dimension, height: 250)
    }
    
    func navigationItems(isEnabled: Bool) {
        DispatchQueue.main.async {
            self.navigationItem.leftBarButtonItem?.isEnabled = isEnabled
            self.createFilterButton.isEnabled = isEnabled
            self.collectionView.isUserInteractionEnabled = isEnabled
        }
    }
    
    func activityIndicator(isAnimating: Bool, indexPath: IndexPath) {
        DispatchQueue.main.async {
            let cell = self.collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
            if isAnimating {
                cell.activityIndicator.startAnimating()
            } else {
                cell.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.allowsMultipleSelection = editing
        collectionView.indexPathsForSelectedItems?.forEach { (indexPath) in
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        let indexPaths = collectionView.indexPathsForVisibleItems
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
            cell.isEditing = editing
        }
        if !editing {
            toolbar.isHidden = true
        }
    }
    
    func updateEditButtonState() {
        switch typeFilterSegmentedControl.selectedSegmentIndex {
        case 0:
            navigationItem.leftBarButtonItem = nil
            setEditing(false, animated: true)
        case 1:
            if fetchedFilterArray.count == 0 {
                navigationItem.leftBarButtonItem = nil
                setEditing(false, animated: true)
            } else {
                navigationItem.leftBarButtonItem = editButtonItem
            }
        default:
            navigationItem.leftBarButtonItem = nil
            setEditing(false, animated: true)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Select Foodlette Winner
    
//    func selectWinnerFrom(data: [Business], minRating: Double = 1.0, maxRating: Double = 5.0) {
//        for _ in data.indices {
//            let winnerSelected = Int.random(in: 0...YelpModel.data.count - 1)
//            if data[winnerSelected].rating >= minRating && data[winnerSelected].rating <= maxRating {
//                foodletteWinner = data[winnerSelected]
//                break
//            } else {
//                showAlert(message: "No restaurants found near you with \(minRating) to \(maxRating) rating. Please try again with a different filter")
//                self.navigationItems(isEnabled: true)
//            }
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PopupViewController {
            controller.defaultFilterSelected = defaultFilterSelected
            controller.createdFilterSelected = createdFilterSelected
//        if let controller = segue.destination as? WinnerViewController {
//            controller.foodletteWinner = foodletteWinner
//            controller.defaultFilterSelected = defaultFilterSelected
//            controller.createdFilterSelected = createdFilterSelected
//        } else if let controller = segue.destination as? PopupViewController {
////            let indexPath = sender as! IndexPath
//            let filter = defaultFilterSelected
//            controller.defaultFilterSelected = filter
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - CollectionView

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch typeFilterSegmentedControl.selectedSegmentIndex {
            case 0: return 1
            case 1: return fetchedResultsController.sections?.count ?? 1
            default: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch typeFilterSegmentedControl.selectedSegmentIndex {
            case 0: return defaultFilter.count
            case 1: return fetchedResultsController.sections?[section].numberOfObjects ?? 0
            default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCollectionViewCell
        switch typeFilterSegmentedControl.selectedSegmentIndex {
            case 0:
                let filter = defaultFilter[indexPath.row]
                cell.filterImageView.image = filter.image
                cell.filterNameLabel.text = filter.name
                cell.filterNarrativeLabel.text = filter.narrative
                applyRoundStylingFor(cell.filterImageView)
                cell.isEditing = isEditing
            case 1:
                let filter = fetchedResultsController.object(at: indexPath)
                if let imageData = filter.image {
                    cell.filterImageView?.image = UIImage(data: imageData)
                }
                cell.filterNameLabel.text = filter.name
                cell.filterNarrativeLabel.text = filter.narrative
                applyRoundStylingFor(cell.filterImageView)
                cell.isEditing = isEditing
            default:
                showAlert(message: "Error loading filters")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch typeFilterSegmentedControl.selectedSegmentIndex {
        case 0:
            let filter = defaultFilter[indexPath.row]
            defaultFilterSelected = filter
            activityIndicator(isAnimating: true, indexPath: indexPath)
            YelpClient.getBusinessDataFor(categories: filter.category ?? "all", latitude: String(latitude), longitude: String(longitude)) { (business, error) in
                guard let business = business else {
                    self.showAlert(message: "Could not load restaurant data. Please check your network connection")
                    self.activityIndicator(isAnimating: false, indexPath: indexPath)
                    return
                }
                YelpModel.data = business
                if business.count == 0 {
                    self.showAlert(message: "No restaurants found near you. Please try again with a different filter")
                    self.activityIndicator(isAnimating: false, indexPath: indexPath)
                } else {
//                    self.selectWinnerFrom(data: YelpModel.data, minRating: filter.minRating ?? 1.0, maxRating: filter.maxRating ?? 5.0)
                    self.activityIndicator(isAnimating: false, indexPath: indexPath)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showPopup", sender: nil)
//                        self.performSegue(withIdentifier: "winnerSegue", sender: nil)
                    }
                }
            }
        case 1:
            let filter = fetchedResultsController.object(at: indexPath)
            createdFilterSelected = filter
            if !isEditing {
                activityIndicator(isAnimating: true, indexPath: indexPath)
                YelpClient.getBusinessDataFor(categories: filter.category ?? "all", latitude: String(latitude), longitude: String(longitude)) { (business, error) in
                    guard let business = business else {
                        self.showAlert(message: "Could not load restaurant data. Please check your network connection")
                        self.activityIndicator(isAnimating: false, indexPath: indexPath)
                        return
                    }
                    YelpModel.data = business
                    if business.count == 0 {
                        self.showAlert(message: "No restaurants found near you. Please try again with a different filter")
                        self.activityIndicator(isAnimating: false, indexPath: indexPath)
                    } else {
//                        guard let filterSelected = self.createdFilterSelected else {
//                            self.showAlert(message: "No filter selected. Please try again")
//                            self.activityIndicator(isAnimating: false, indexPath: indexPath)
//                            return
//                        }
//                        self.selectWinnerFrom(data: YelpModel.data, minRating: filterSelected.minRating, maxRating: filterSelected.maxRating)
                        self.activityIndicator(isAnimating: false, indexPath: indexPath)
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "winnerSegue", sender: nil)
                        }
                    }
                }
            } else {
                toolbar.isHidden = false
                updateEditButtonState()
            }
        default:
            showAlert(message: "Error selecting filters")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if let selected = collectionView.indexPathsForSelectedItems, selected.count == 0 {
                toolbar.isHidden = true
            }
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - LocationManager

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userCoordinates: CLLocationCoordinate2D = manager.location?.coordinate else {
            showAlert(message: "Unable to find your location")
            locationManager.stopUpdatingLocation()
            return
        }
        latitude = userCoordinates.latitude
        longitude = userCoordinates.longitude
        locationManager.stopUpdatingLocation()
    }
}
