//
//  GIFBaseAPI.swift
//  GIFMe
//
//  Created by Francis Lata on 2017-01-19.
//  Copyright © 2017 Francis Lata. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GIFBaseAPI {
    // MARK: Properties
    static let sharedGIFBaseAPI = GIFBaseAPI()
    
    // MARK: Public Methods
    func retrieveGIFs(withTag tag: String, completionHandler: @escaping ([GIF]?, Int, Int, Error?) -> Void) {
        let retrieveGIFsURL = Constants.gifBaseBaseURL + Constants.gifBaseAPITagEndpoint + tag + Constants.httpParameterStartString + Constants.gifBaseFormatJSONParameterAndValue
        
        Alamofire.request(retrieveGIFsURL).validate().responseJSON {response in
            switch response.result {
                case .success(let value):
                    let jsonSerializedValue = JSON(value)
                    self.serializeGIFs(gifs: jsonSerializedValue, completionHandler: { serializedGIFs in
                        completionHandler(serializedGIFs, jsonSerializedValue[Constants.gifBasePageCurrentKey].intValue, jsonSerializedValue[Constants.gifBasePageCountKey].intValue, nil)
                    })
                case .failure(let error):
                    completionHandler(nil, 0, 0, error)
            }
        }
    }
    
    
    // MARK: Serializer methods
    fileprivate func serializeGIFs(gifs: JSON, completionHandler: @escaping ([GIF]?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var serializedGIFs = [GIF]()
            
            for (_, gif) in gifs[Constants.gifBaseGIFsKey] {
                serializedGIFs.append(GIF(date: Double(gif[Constants.gifBaseDateKey].stringValue)!, id: gif[Constants.gifBaseIDKey].stringValue, url: gif[Constants.gifBaseURLKey].stringValue, username: gif[Constants.gifBaseUsernameKey].stringValue))
            }
            
            DispatchQueue.main.async {
                completionHandler(serializedGIFs.isEmpty ? nil : serializedGIFs)
            }
        }
    }
}
