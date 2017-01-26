//
//  GIFDetailViewController.swift
//  GIFMe
//
//  Created by Francis Lata on 2017-01-26.
//  Copyright © 2017 Francis Lata. All rights reserved.
//

import UIKit
import PHImageKit

class GIFDetailViewController: UIViewController, UITableViewDataSource, GIFDetailRatingTableViewCellDelegate {
    // MARK: Properties
    @IBOutlet weak var gifDetailTableView: UITableView!
    var gif: GIF?
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableHeaderView()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "BASIC INFORMATION"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GIFDetailInformationTableViewCell.self), for: indexPath) as! GIFDetailInformationTableViewCell
                cell.titleLabel.text = "Username"
                cell.contentLabel.text = gif?.username
                
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GIFDetailRatingTableViewCell.self), for: indexPath) as! GIFDetailRatingTableViewCell
                if let rating = gif?.rating { cell.starRatingView.value = CGFloat(rating) }
                cell.delegate = self
            
                return cell
        }
    }
    
    // MARK: GIFDetailRatingTableViewCellDelegate
    func gifDetailRatingTableViewCell(_ cell: GIFDetailRatingTableViewCell, didRateWithValue rating: Float) {
        gif?.rating = rating
    }
    
    // MARK: Helper methods
    func setupTableHeaderView() {
        let gifImageView = gifDetailTableView.tableHeaderView!.viewWithTag(1000) as! PHImageView
        gifImageView.url = gif?.url
    }
}
