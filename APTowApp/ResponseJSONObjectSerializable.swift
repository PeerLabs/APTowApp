//
//  ResponseJSONObjectSerializable.swift
//  APTowApp
//
//  Created by Abrar Peer on 22/09/2016.
//  Copyright © 2016 AppsDesignLab. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol ResponseJSONObjectSerializable {
    
    init?(json: SwiftyJSON.JSON)
    
}

