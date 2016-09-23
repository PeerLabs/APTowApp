//
//  TowLocationPostResponse.swift
//  APTowApp
//
//  Created by Abrar Peer on 23/09/2016.
//  Copyright © 2016 AppsDesignLab. All rights reserved.
//

import Foundation
import SwiftyJSON

class TowLocationPostResponse : ResponseJSONObjectSerializable, CustomStringConvertible {
    
    var statusCode : Int?
    var errorMessage : String?
    
    required init(json: JSON) {

        self.statusCode = json["status"].int
        self.errorMessage = json["error"].string
        
    }
    
    required init() {
        
    }
    
    var description : String {
        
        return "Status: \(self.statusCode), Error: \(self.errorMessage)"
        
    }
    
    
}
