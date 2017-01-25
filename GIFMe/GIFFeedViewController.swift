//
//  GIFFeedViewController.swift
//  GIFMe
//
//  Created by Francis Lata on 2017-01-21.
//  Copyright © 2017 Francis Lata. All rights reserved.
//

import UIKit
import PHImageKit

class GIFFeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties
    @IBOutlet weak var gifFeedTableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var gifs: [GIF]?
    private var currentFeedPage = 0
    private var totalFeedPages = 0
    private var morePagesAvailable: Bool { return currentFeedPage < totalFeedPages }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let gifsCount = gifs?.count {
            if (indexPath.row < gifsCount) {
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
        guard let gifsCount = gifs?.count else { return 0 }
        
        return gifsCount + ((morePagesAvailable) ? 1 : 0)
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let gifsCount = gifs?.count {
            if indexPath.row == gifsCount - 1 && morePagesAvailable {
                retrieveAndRefreshGIFFeed()
            }
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
    }
    
    private func setupTableView() {
        // Register cells
        gifFeedTableView.register(UINib.init(nibName: String(describing: GIFFeedPreviewTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: GIFFeedPreviewTableViewCell.self))
        gifFeedTableView.register(UINib.init(nibName: String(describing: GIFFeedLoadingTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: GIFFeedLoadingTableViewCell.self))
    }
    
    private func retrieveAndRefreshGIFFeed() {
        GIFBaseAPI.sharedGIFBaseAPI.retrieveGIFs(withTag: "cool", forPage: currentFeedPage + 1) { (gifs, currentPage, totalPages, error) in
            guard error == nil else { return }
            
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
            
            // Reload the table view to display results
            self.gifFeedTableView.reloadData()
        }
    }
}
