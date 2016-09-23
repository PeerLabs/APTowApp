//
//  TowAPIManager.swift
//  APTowApp
//
//  Created by Abrar Peer on 22/09/2016.
//  Copyright © 2016 AppsDesignLab. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TowAPIManager {
    
    static let sharedInstance = TowAPIManager()
    
    var alamofireManager:Alamofire.Manager
    
    let headers = ["Accept": "application/json"]
    
    init () {
        
        log?.debug("Started!")
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        alamofireManager = Alamofire.Manager(configuration: configuration)
        
        log?.debug("Finished!")
        
    }
    
    
    
    func getLogin(username: String, password: String, completionHandler: (Result<TowLogin, NSError>) -> Void) {
        
        log?.debug("Started!")
        
        Alamofire.request(TowRouter.GetLogin(username: username, password: password)).responseObject { (response: Response<TowLogin, NSError>) in

            guard let towLogin = response.result.value else {
                log?.debug(response.result.error)
                completionHandler(response.result)
                return
                    
            }
            
            log?.debug("\(towLogin)")
            
            log?.debug("Finished!")
            completionHandler(.Success(towLogin))
            
        }

        log?.debug("Finished!")

    }
    
    func postLocation(accessToken: String, uid: Int , latitude: AnyObject, longitude: AnyObject, completionHandler: (Result<TowResponse, NSError>) -> Void) {
        
        log?.debug("Started!")
        
        Alamofire.request(TowRouter.PostLocation(accessToken: accessToken, userId: uid, lat: latitude, lng: longitude)).responseObject { (response: Response<TowResponse, NSError>) in
            
            guard let towLocPostResp = response.result.value else {
                log?.debug(response.result.error)
                completionHandler(response.result)
                return
                
            }

            log?.debug("Finished!")
            completionHandler(.Success(towLocPostResp))
            
        }
        
        log?.debug("Finished!")
        
    }
    
    func getLogout(accessToken: String, completionHandler: (Result<TowResponse, NSError>) -> Void) {
        
        log?.debug("Started!")
        
        Alamofire.request(TowRouter.GetLogout(accessToken: accessToken)).responseObject { (response: Response<TowResponse, NSError>) in
            
            guard let towResp = response.result.value else {
                log?.debug(response.result.error)
                completionHandler(response.result)
                return
                
            }
            
            log?.debug("Finished!")
            
            completionHandler(.Success(towResp))
            
        }
        
        log?.debug("Finished!")
        
    }
    


    
}
