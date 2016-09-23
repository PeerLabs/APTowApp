//
//  TowLogin.swift
//  APTowApp
//
//  Created by Abrar Peer on 22/09/2016.
//  Copyright © 2016 AppsDesignLab. All rights reserved.
//

import Foundation
import SwiftyJSON

class TowLogin : ResponseJSONObjectSerializable, CustomStringConvertible {
    
    var accessToken: String?
    var uid: Int?
    var statusCode : Int?
    var errorMessage : String?
    
    required init(json: JSON) {
        
        self.accessToken = json["accessToken"].string
        self.uid = json["uid"].int
        self.statusCode = json["status"].int
        self.errorMessage = json["error"].string
        
    }
    
    required init() {
        
    }
    
    var description : String {
        
        return "AccessToken: \(self.accessToken), Uid: \(self.uid), Status: \(self.statusCode), Error: \(self.errorMessage)"
        
    }
    
    
}

