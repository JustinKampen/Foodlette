//
//  RecentsViewController.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/27/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit
import CoreData

class RecentsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // -------------------------------------------------------------------------
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }()
    let searchController = UISearchController(searchResultsController: nil)
    var dataController = DataController.shared
    var fetchedResultsController: NSFetchedResultsController<Restaurant>!
    var restaurant: Restaurant?
    var recents = [Restaurant]()
    var searchedRecents = [Restaurant]()
    
    // -------------------------------------------------------------------------
    // MARK: - Fetching CoreData

    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            recents = fetchedResultsController.fetchedObjects ?? []
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupFetchedResultsController()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI Display
    
    func displayRatingImage(for rating: Double) -> UIImage {
        var ratingImage: UIImage {
            switch rating {
            case 0.0...0.9: return #imageLiteral(resourceName: "small_0")
            case 1.0...1.4: return #imageLiteral(resourceName: "small_1")
            case 1.5...1.9: return #imageLiteral(resourceName: "small_1_half")
            case 2.0...2.4: return #imageLiteral(resourceName: "small_2")
            case 2.5...2.9: return #imageLiteral(resourceName: "small_2")
            case 3.0...3.4: return #imageLiteral(resourceName: "small_3")
            case 3.5...3.9: return #imageLiteral(resourceName: "small_3_half")
            case 4.0...4.4: return #imageLiteral(resourceName: "small_4")
            case 4.5...4.9: return #imageLiteral(resourceName: "small_4_half")
            case 5.0: return #imageLiteral(resourceName: "small_5")
            default:
                return #imageLiteral(resourceName: "small_0")
            }
        }
        return ratingImage
    }

    // -------------------------------------------------------------------------
    // MARK: - Search Bar Functionality
    
    func setupSearchBar() {
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recents"
        definesPresentationContext = true
        let offset = CGPoint.init(x:0, y: searchController.searchBar.bounds.height)
        tableView.setContentOffset(offset, animated: false)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchedRecents = recents.filter({( restaurant : Restaurant) -> Bool in
            if let restaurantName = restaurant.name {
                return restaurantName.lowercased().contains(searchText.lowercased())
            }
            return false
        })
        tableView.reloadData()
    }

    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    func isSearching() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI Functionality
    
    func deleteRecent(at indexPath: IndexPath) {
        let recentToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(recentToDelete)
        dataController.saveViewContext()
    }
    
    func updateEditButtonState() {
        if let sections = fetchedResultsController.sections {
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Show Restraunt Details Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recentDetail" {
            let controller = segue.destination as! DetailedViewController
            controller.restaurant = restaurant
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Favorable Protocol

extension RecentsViewController: RecentFavorable {
    
    func didTapFavoriteButton(for restaurant: Restaurant) {
        if restaurant.isFavorite {
            restaurant.isFavorite = false
        } else {
            restaurant.isFavorite = true
        }
        dataController.saveViewContext()
    }
}

// -----------------------------------------------------------------------------
// MARK: - TableView

extension RecentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching() {
            return searchedRecents.count
        }
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return searchedRecents.count
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentsCell", for: indexPath) as! RecentsTableViewCell
        let recent: Restaurant
        if isSearching() {
            recent = searchedRecents[indexPath.row]
        } else {
            recent = fetchedResultsController.object(at: indexPath)
        }
        if let imageData = recent.image {
            cell.recentImageView?.image = UIImage(data: imageData)
            cell.recentImageView.layer.cornerRadius = 5.0
        }
        cell.recentNameLabel.text = recent.name
        cell.recentFilterSelectedLabel.text = recent.withFilter
        if let date = recent.date {
            cell.recentDateLabel.text = dateFormatter.string(from: date)
        }
        cell.recentRatingImageView.image = displayRatingImage(for: recent.rating)
        cell.recentReviewCountLabel.text = recent.reviewCount
        if recent.isFavorite {
            cell.isFavoriteButton.setImage(#imageLiteral(resourceName: "filled-heart-50"), for: .normal)
        } else {
            cell.isFavoriteButton.setImage(#imageLiteral(resourceName: "open-heart-50"), for: .normal)
        }
        cell.setRestaurants(recent: recent)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteRecent(at: indexPath)
        default:
            ()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        restaurant = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "recentDetail", sender: nil)
    }
}

// -----------------------------------------------------------------------------
// MARK: - Fetched Results Controller

extension RecentsViewController {

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .move:
            ()
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        @unknown default:
            ()
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - Search Results Updating

extension RecentsViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension RecentsViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        setupSearchBar()
    }
}
