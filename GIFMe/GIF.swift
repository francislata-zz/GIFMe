//
//  GIF.swift
//  GIFMe
//
//  Created by Francis Lata on 2017-01-17.
//  Copyright © 2017 Francis Lata. All rights reserved.
//

import Foundation

class GIF {
    // MARK: Properties
    let date: Date
    let id: String
    let url: URL?
    let username: String
    
    // MARK: Methods
    init(date: Double, id: String, url: String, username: String) {
        self.date = Date(timeIntervalSince1970: date)
        self.id = id
        self.url = URL(string: url)
        self.username = username
    }
}
