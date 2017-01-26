//
//  GIFDetailRatingTableViewCell.swift
//  GIFMe
//
//  Created by Francis Lata on 2017-01-26.
//  Copyright © 2017 Francis Lata. All rights reserved.
//

import UIKit

protocol GIFDetailRatingTableViewCellDelegate: class {
    func gifDetailRatingTableViewCell(_ cell: GIFDetailRatingTableViewCell, didRateWithValue rating: Float)
}

class GIFDetailRatingTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var starRatingView: SwiftyStarRatingView!
    weak var delegate: GIFDetailRatingTableViewCellDelegate?
    
    // MARK: IBAction methods
    @IBAction func ratingChanged(_ sender: SwiftyStarRatingView) {
        delegate?.gifDetailRatingTableViewCell(self, didRateWithValue: Float(sender.value))
    }
    
    // MARK: View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup rating view
        starRatingView.allowsHalfStars = false
    }
}
