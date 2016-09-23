//
//  TowRouter.swift
//  APTowApp
//
//  Created by Abrar Peer on 22/09/2016.
//  Copyright © 2016 AppsDesignLab. All rights reserved.
//

import Foundation
import Alamofire

enum TowRouter : URLRequestConvertible {
    
    static let baseURLString = "https://tow.com.au/api/ios"
    static let apiKey = "7dc82bcd2b458b0a9fca5528c6672d60"
    static let headers = ["Content-type application":"json", "Accept application" : "json"]
    
    case GetLogin(username: String, password: String) // GET https://tow.com.au/api/ios/login.json
    
    case PostLocation(accessToken: String, userId: Int, lat: AnyObject, lng: AnyObject) // POST https://tow.com.au/api/ios/ping.json
    
    var URLRequest: NSMutableURLRequest {
        
        var method: Alamofire.Method {
            
            switch self {
                
            case .GetLogin:
                
                return .GET

            case .PostLocation:
            
                return .POST
                
            }
            
        }
        
        let result : (path: String, parameters: [String : AnyObject]?) = {
            
            switch self {
                
            case .GetLogin(let (username, password)):
                
                let params = ["apiKey": "7dc82bcd2b458b0a9fca5528c6672d60", "username": username, "password": password]
                
                return ("/login.json", params)
                
            case .PostLocation(let(accessToken, uid, latitude, longitude)):
                
                let params = ["accessToken": accessToken, "uid": uid, "lat": latitude, "lng": longitude]
                
                return ("/ping.json", params)
                
            }

            
        }()
        
        
        let URL = NSURL(string: TowRouter.baseURLString)!
        
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(result.path))
        
        let encoding = Alamofire.ParameterEncoding.URL
        
        let (encodedRequest, _) = encoding.encode(URLRequest, parameters: result.parameters)
        
        encodedRequest.HTTPMethod = method.rawValue
        
        log?.debug("Encoded Request = \(encodedRequest.URL)")
        
        return encodedRequest
        
    }

}
