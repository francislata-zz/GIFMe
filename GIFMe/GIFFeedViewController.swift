//
//  GIFFeedViewController.swift
//  GIFMe
//
//  Created by Francis Lata on 2017-01-21.
//  Copyright © 2017 Francis Lata. All rights reserved.
//

import UIKit
import PHImageKit

class GIFFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    // MARK: Properties
    @IBOutlet weak var gifFeedTableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var gifs: [GIF]?
    private var searchedGIFResults: [GIF]?
    private var currentFeedPage = 0
    private var totalFeedPages = 0
    private var searchedGIFCurrentFeedPage = 0
    private var searchedGIFTotalFeedPages = 0
    private var morePagesAvailable: Bool { return (searchController.isActive) ? searchedGIFCurrentFeedPage < searchedGIFTotalFeedPages : currentFeedPage < totalFeedPages }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (searchController.isActive) {
            if let searchedGIFResultsCount = searchedGIFResults?.count {
                if searchedGIFResultsCount > 0 && indexPath.row < searchedGIFResultsCount {
                    let gif: GIF = searchedGIFResults![indexPath.row]
                    let cell: GIFFeedPreviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: GIFFeedPreviewTableViewCell.self), for: indexPath) as! GIFFeedPreviewTableViewCell
                    cell.gifPreviewImageView.url = gif.url
                    
                    return cell
                }
            }
        }
        
        if let gifsCount = gifs?.count {
            if indexPath.row < gifsCount {
                let gif: GIF = gifs![indexPath.row]
                let cell: GIFFeedPreviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: GIFFeedPreviewTableViewCell.self), for: indexPath) as! GIFFeedPreviewTableViewCell
                cell.gifPreviewImageView.url = gif.url
                
                return cell
            }
        }
        
        let cell: GIFFeedLoadingTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: GIFFeedLoadingTableViewCell.self), for: indexPath) as! GIFFeedLoadingTableViewCell
        cell.loadingActivityIndicatorView.startAnimating()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            if let searchedGIFResultsCount = searchedGIFResults?.count {
                if searchedGIFResultsCount > 0 {
                    return searchedGIFResultsCount + ((morePagesAvailable) ? 1 : 0)
                }
            }
        }
        
        guard let gifsCount = gifs?.count else { return 0 }
        
        return gifsCount + ((morePagesAvailable) ? 1 : 0)
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchController.isActive {
            if let searchedGIFResultsCount = searchedGIFResults?.count {
                if searchedGIFTotalFeedPages > 0 && indexPath.row == searchedGIFResultsCount - 1 && morePagesAvailable {
                    retrieveAndRefreshGIFFeed(withTag: searchController.searchBar.text!, forPage: searchedGIFCurrentFeedPage + 1)
                }
            }
        }
        
        guard let gifsCount = gifs?.count else { return }
        
        if searchedGIFTotalFeedPages == 0 && indexPath.row == gifsCount - 1 && morePagesAvailable { retrieveAndRefreshGIFFeed(forPage: currentFeedPage + 1) }
    }
    
    // MARK: UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchKeyword = searchController.searchBar.text else { return }
        
        if searchKeyword.isEmpty {
            resetGIFFeedState()
        } else {
            retrieveAndRefreshGIFFeed(withTag: searchKeyword)
        }
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupTableView()
        retrieveAndRefreshGIFFeed()
    }
    
    // MARK: Helper methods
    private func setupSearchController() {
        // Set the title view to be the search bar
        navigationItem.titleView = searchController.searchBar
        
        // Set properties of the search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    private func setupTableView() {
        // Register cells
        gifFeedTableView.register(UINib.init(nibName: String(describing: GIFFeedPreviewTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: GIFFeedPreviewTableViewCell.self))
        gifFeedTableView.register(UINib.init(nibName: String(describing: GIFFeedLoadingTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: GIFFeedLoadingTableViewCell.self))
    }
    
    private func retrieveAndRefreshGIFFeed(withTag tag: String = "cool", forPage page: Int = 0) {
        GIFBaseAPI.sharedGIFBaseAPI.retrieveGIFs(withTag: tag, forPage: page) { (gifs, currentPage, totalPages, error) in
            guard error == nil else { return }
            
            if self.searchController.isActive {
                // Keep references to the searched current page and total pages
                self.searchedGIFCurrentFeedPage = currentPage;
                self.searchedGIFTotalFeedPages = totalPages;
                
                // Retrieve the gifs
                if self.searchedGIFCurrentFeedPage > 1 {
                    guard let newSearchedGIFResults = gifs else { return }
                    
                    self.searchedGIFResults?.append(contentsOf: newSearchedGIFResults)
                } else {
                    self.searchedGIFResults = gifs
                }
            } else {
                // Keep references to the current page and total pages
                self.currentFeedPage = currentPage;
                self.totalFeedPages = totalPages;
                
                // Retrieve the gifs
                if self.currentFeedPage > 1 {
                    guard let newGifs = gifs else { return }
                    
                    self.gifs?.append(contentsOf: newGifs)
                } else {
                    self.gifs = gifs
                }
            }
            
            // Reload the table view to display results
            self.gifFeedTableView.reloadData()
        }
    }
    
    private func resetGIFFeedState() {
        // Clear search results state
        self.searchedGIFResults = nil
        self.searchedGIFCurrentFeedPage = 0
        self.searchedGIFTotalFeedPages = 0
        
        // Reload to show the GIF feed
        gifFeedTableView.reloadData()
        
        // Scroll to top of the feed
        if let _ = gifs?.count {
            gifFeedTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
        }
    }
}
