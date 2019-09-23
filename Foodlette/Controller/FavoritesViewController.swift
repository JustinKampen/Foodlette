//
//  FavoritesViewController.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // -------------------------------------------------------------------------
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var dataController = DataController.shared
    var fetchedResultsController: NSFetchedResultsController<Restaurant>!
    var restaurant: Restaurant?
    var favorites = [Restaurant]()
    var searchedFavorites = [Restaurant]()
    
    // -------------------------------------------------------------------------
    // MARK: - Fetching CoreData
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            favorites = fetchedResultsController.fetchedObjects ?? []
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
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recents"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        let offset = CGPoint.init(x:0, y: searchController.searchBar.bounds.height)
        tableView.setContentOffset(offset, animated: false)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        searchedFavorites = favorites.filter({( restaurant : Restaurant) -> Bool in
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
    // MARK: - Show Restraunt Details Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteDetail" {
            let controller = segue.destination as! DetailedViewController
            controller.restaurant = restaurant
        }
    }   
}

// -----------------------------------------------------------------------------
// MARK: - Favorable Protocol

extension FavoritesViewController: Favorable {
    
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

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearching() {
            return searchedFavorites.count
        }
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching() {
            return searchedFavorites.count
        }
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath) as! FavoritesTableViewCell
        let favorite: Restaurant
        if isSearching() {
            favorite = searchedFavorites[indexPath.row]
        } else {
            favorite = fetchedResultsController.object(at: indexPath)
        }
        cell.favoriteNameLabel.text = favorite.name
        cell.favoriterestaurantCategoryLabel.text = favorite.category
        cell.favoriteRatingImageView.image = displayRatingImage(for: favorite.rating)
        cell.favoriteReviewCountLabel.text = favorite.reviewCount
        if let imageDate = favorite.image {
            cell.favoriteImageView?.image = UIImage(data: imageDate)
            cell.favoriteImageView.layer.cornerRadius = 5.0
        }
        cell.isFavoriteButton.setImage(#imageLiteral(resourceName: "filled-heart-50"), for: .normal)
        cell.setRestaurants(favorite: favorite)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        restaurant = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: "favoriteDetail", sender: nil)
    }
}

// -----------------------------------------------------------------------------
// MARK: - Fetched Results Controller

extension FavoritesViewController {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        tableView.deleteRows(at: [indexPath!], with: .fade)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

// -----------------------------------------------------------------------------
// MARK: - Search Results Updating

extension FavoritesViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

extension FavoritesViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setupSearchBar()
    }
}
