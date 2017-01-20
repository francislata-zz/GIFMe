//
//  Constants.swift
//  GIFMe
//
//  Created by Francis Lata on 2017-01-17.
//  Copyright © 2017 Francis Lata. All rights reserved.
//

import Foundation

struct Constants {
    // MARK: GIFBase API
    static let gifBaseBaseURL = "http://gifbase.com/"
    
    static let gifBaseAPIGIFEndpoint = "gif/"
    static let gifBaseAPITagEndpoint = "tag/"
    
    static let gifBaseFormatJSONParameterAndValue = "format=json"
    static let gifBasePageParameter = "p="
    
    static let gifBaseGIFsKey = "gifs"
    static let gifBaseDateKey = "date"
    static let gifBaseIDKey = "id"
    static let gifBaseURLKey = "url"
    static let gifBaseUsernameKey = "username"
    static let gifBasePageCurrentKey = "page_current"
    static let gifBasePageCountKey = "page_count"
    
    // MARK: HTTP
    static let httpParameterStartString = "?"
    static let httpParameterAppendString = "&"
}
