//
//  ViewController.swift
//  APTowApp
//
//  Created by Abrar Peer on 21/09/2016.
//  Copyright © 2016 AppsDesignLab. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    //Buttons
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    //Session Status Labels
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var accessTokenLabel: UILabel!
    @IBOutlet weak var uidLabel: UILabel!
    @IBOutlet weak var logonTimeLabel: UILabel!
    
    //Current Location Info Labels
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var lattitudeLabel: UILabel!
    
    //Last Posted Location Info Labels
    @IBOutlet weak var lastPostedLongitudeLabel: UILabel!
    @IBOutlet weak var lastPostedLattitudeLabel: UILabel!
    @IBOutlet weak var lastPostedTimeStampLabel: UILabel!
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    
    //Model Objets
    var isLoggedIn = false
    var towLogin : TowLogin?
    var username = ""
    var password = ""
    
    //Formatter Objects
    let dateFormatter = NSDateFormatter()
    
    //Location Manager
    let locationManager = CLLocationManager()
    
    //Update Interval 
    let updateSecondsInterval = 30 //  Between 1 - 60
    
    let notSetText = "<not set>"
    
    var numberOfPosts = 0 {
        
        didSet{
            
            self.numberOfPostsLabel.text = String(numberOfPosts)
            
        }
        
    }
    
    override func viewDidLoad() {
        
        log?.debug("Started!")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loginButton.enabled = true
//        self.loginButton.hidden = false
        self.logoutButton.enabled = false
//        self.logoutButton.hidden = true
        
        dateFormatter.dateFormat = "dd MMM YYYY, HH:mm:ss"
        
        self.numberOfPostsLabel.text = String(numberOfPosts)
        
        log?.debug("Finished!")
        
    }

    override func didReceiveMemoryWarning() {
        
        log?.debug("Started!")
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        log?.debug("Finished!")
        
    }

    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        log?.debug("Started!")
        
        let alertController = UIAlertController(title: "Login to tow.com.au", message: "Please enter your credentials.", preferredStyle: .Alert)
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action:UIAlertAction) in
            //This is called when the user presses the cancel button.
            log?.debug("User pressed the cancel button");
        }
        
        let actionLogin = UIAlertAction(title: "Login", style: .Default) { (action:UIAlertAction) in
            //This is called when the user presses the login button.
            let textUser = alertController.textFields![0] as UITextField
            let textPW = alertController.textFields![1] as UITextField
            
            //checking for empty username
            if let username = textUser.text {
                
                if username.isEmpty {
                    
                    let warningAlertController = UIAlertController(title: "Login Error", message: "You need to enter a username!", preferredStyle: .Alert)
                    
                    let retryAction = UIAlertAction(title: "Retry", style: .Default) {
                        
                        (action:UIAlertAction) in log?.debug("You Pressed Retry Button");
                        
                    }
                    
                    warningAlertController.addAction(retryAction)
                    self.presentViewController(warningAlertController, animated: true, completion:nil)

                } else {
                    
                    log?.debug("Username = \(username)")
                    
                    self.username = username
                    
                }
                
            }
            
            //checking for empty password
            if let password = textPW.text {
                
                if password.isEmpty {
                    
                    let warningAlertController = UIAlertController(title: "Login Error", message: "You need to enter a password!", preferredStyle: .Alert)
                    
                    let retryAction = UIAlertAction(title: "Retry", style: .Default) {
                        
                        (action:UIAlertAction) in log?.debug("You Pressed Retry Button");
                        
                    }
                    
                    warningAlertController.addAction(retryAction)
                    self.presentViewController(warningAlertController, animated: true, completion:nil)
                    
                } else {
                    
                    log?.debug("Password = \(password)")
                    
                    self.password = password
                    
                }
                
            }
            
            //do login
            self.loginToTow()

        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            //Configure the attributes of the first text box.
            textField.placeholder = "Username"
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            //Configure the attributes of the second text box.
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        }
        
        //Add the buttons
        alertController.addAction(actionCancel)
        alertController.addAction(actionLogin)
        
        //Present the alert controller
        self.presentViewController(alertController, animated: true, completion:nil)
        
        log?.debug("Finished!")
        
    }
    
    func loginToTow() {
        
        log?.debug("Started!")
        
        log?.debug("Username = \(self.username)")
        log?.debug("Password = \(self.password)")
        
        TowAPIManager.sharedInstance.getLogin(self.username, password: self.password) { (result) in
            
            guard result.error == nil else {
                
                log?.debug("Error = \(result.error)")
                
                let alertController = UIAlertController(title: "Login Error", message: "\(result.error)", preferredStyle: .Alert)
                
                let retryAction = UIAlertAction(title: "Retry", style: .Default) {
                    
                    (action:UIAlertAction) in
                    
                    log?.debug("You Pressed Retry Button");

                }
                
                alertController.addAction(retryAction)
                self.presentViewController(alertController, animated: true, completion:nil)
                
                log?.debug("Finished!")
                
                return

            }
            
            self.towLogin = result.value!
            
            if let errMsg = self.towLogin?.errorMessage {
                
                if (!errMsg.isEmpty) {
                    
                    log?.debug("Error = \(errMsg)")
                    
                    let alertController = UIAlertController(title: "Login Error", message: "\(errMsg)", preferredStyle: .Alert)
                    
                    let retryAction = UIAlertAction(title: "Retry", style: .Default) {
                        
                        (action:UIAlertAction) in
                        
                        log?.debug("You Pressed Retry Button");
                        
                    }
                    
                    alertController.addAction(retryAction)
                    self.presentViewController(alertController, animated: true, completion:nil)
                    
                }
                
            }
            
            guard (self.towLogin?.accessToken != nil) else {
                
                let alertController = UIAlertController(title: "Login Error", message: "Did not Recieve an Access Token. Please try logging again!", preferredStyle: .Alert)
                
                let retryAction = UIAlertAction(title: "Ok", style: .Default) {
                    
                    (action:UIAlertAction) in
                    
                    log?.debug("You Pressed Retry Button");
                    
                }
                
                alertController.addAction(retryAction)
                self.presentViewController(alertController, animated: true, completion:nil)
                
                log?.debug("Finished!")
                
                return

            }
            
            guard (self.towLogin?.uid != nil) else {
                
                let alertController = UIAlertController(title: "Login Error", message: "Did not Recieve a User ID. Please try logging again!", preferredStyle: .Alert)
                
                let retryAction = UIAlertAction(title: "Ok", style: .Default) {
                    
                    (action:UIAlertAction) in
                    
                    log?.debug("You Pressed Retry Button");
                    
                }
                
                alertController.addAction(retryAction)
                self.presentViewController(alertController, animated: true, completion:nil)
                
                log?.debug("Finished!")
                
                return
                
            }
            
            self.accessTokenLabel.text = self.towLogin?.accessToken!
            
            self.messageLabel.text = "User \"\(self.username)\" Logged In!"
            
            let uid = self.towLogin?.uid!
            
            self.uidLabel.text = String(uid!)
            
            self.logonTimeLabel.text = self.dateFormatter.stringFromDate(NSDate())
            
            self.loginButton.enabled = false
//            self.loginButton.hidden = true
            self.logoutButton.enabled = true
//            self.logoutButton.hidden = false
            
            
            if CLLocationManager.authorizationStatus() == .NotDetermined {
                self.locationManager.requestAlwaysAuthorization()
            }
            
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.delegate = self
            
            self.locationManager.startUpdatingLocation()
            

        }

        log?.debug("Finished!")
        
    }
    
    @IBAction func logoutButtonTapped(sender: AnyObject) {
        
        log?.debug("Started!")
        
        self.locationManager.stopUpdatingLocation()
        
        self.logoutOfTow()
        
        log?.debug("Finished!")
        
    }
    
    
    func logoutOfTow() {
        
        log?.debug("Started!")
        
//        TowAPIManager.sharedInstance.getLogout((self.towLogin?.accessToken)!) //{ (result) in
//
//            guard result.error == nil else {
//                
//                log?.debug("An error occured whilst trying to logout. Error: \(result.error)")
//                
//                return
//                
//            }
//            
//            let towResp = result.value!
//            
//            switch (towResp.statusCode!) {
//                
//            default:
//                
//                
//                
//                
//            }

            
            
            
//        }
        
        self.messageLabel.text = "Currently No User Installed!"
        self.accessTokenLabel.text = self.notSetText
        self.uidLabel.text = self.notSetText
        self.logonTimeLabel.text = self.notSetText
        self.lattitudeLabel.text = self.notSetText
        self.longitudeLabel.text = self.notSetText
        self.lastPostedLattitudeLabel.text = self.notSetText
        self.lastPostedLongitudeLabel.text = self.notSetText
        self.lastPostedTimeStampLabel.text = self.notSetText
        self.towLogin?.accessToken = nil
        self.towLogin?.uid = nil
        self.towLogin?.statusCode = nil
        self.towLogin?.errorMessage = nil

        self.logoutButton.enabled = false
        self.loginButton.enabled = true
        
//        self.username = ""
//        self.password = ""
        
        log?.debug("Finished!")
        
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        log?.debug("Started!")
        
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            
            self.locationManager.startUpdatingLocation()

        }
        
        log?.debug("Finished!")
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        log?.debug("Started!")
        
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        let longitude = String(format: "%.4f", latestLocation.coordinate.longitude)
        let latitude = String(format: "%.4f", latestLocation.coordinate.latitude)
        
        self.longitudeLabel.text = longitude
        self.lattitudeLabel.text = latitude
        
        //Date Time Objects
        let date = NSDate()
        let calender = NSCalendar.currentCalendar()
        let components = calender.components([.Hour, .Minute, .Second], fromDate: date)
        let seconds = components.second
        
        if (seconds % self.updateSecondsInterval == 0) {
            
            log?.debug("Updating API with (Longitude = \(longitude), Lattitude = \(latitude))")
            
            guard let token = self.towLogin?.accessToken! else {
                
                return
                
                
            }
            guard let uid = self.towLogin?.uid! else {
                
                return
            }
            
            TowAPIManager.sharedInstance.postLocation(token, uid: uid, latitude: latitude, longitude: longitude) { (result) in
                
                guard result.error == nil else {
                    
                    log?.debug("An error occured whilst trying to post location. Error: \(result.error)")
                    
                    return
                
                }
                
                let towlocationPostResp = result.value!
                
                switch (towlocationPostResp.statusCode!) {
                    
                case 200:
                    
                    log?.debug("We successfully posted (Longitude = \(longitude), Lattitude = \(latitude) to API with accessToken \"\((self.towLogin?.accessToken)!) and UserID of \((self.towLogin?.uid)!)")
                    self.lastPostedLattitudeLabel.text = latitude
                    self.lastPostedLongitudeLabel.text = longitude
                    self.lastPostedTimeStampLabel.text = self.dateFormatter.stringFromDate(NSDate())
                    self.numberOfPosts += 1
                    
                case 400:
                    
                    log?.debug("An Error occured while trying to post (Longitude = \(longitude), Lattitude = \(latitude) to API with accessToken \"\((self.towLogin?.accessToken)!) and UserID of \((self.towLogin?.uid)!)")
                    log?.debug("Status Code: \(towlocationPostResp.statusCode!)")
                    log?.debug("Error Message: \(towlocationPostResp.errorMessage!)")
                    
                    self.messageLabel.text = "Logging Out"
                    
                    self.logoutOfTow()
                    
                    self.messageLabel.text = "Relogging in!"
                    
                    //Relogging in
                    
                    self.loginToTow()

                    
                default:
                    
                    log?.debug("An Error occured while trying to post (Longitude = \(longitude), Lattitude = \(latitude) to API with accessToken \"\(token) and UserID of \(uid)")
                    log?.debug("Status Code: \(towlocationPostResp.statusCode!)")
                    log?.debug("Error Message: \(towlocationPostResp.errorMessage!)")
                    
                    self.messageLabel.text = "Logging Out"
                    
                    self.logoutOfTow()
                    
                    self.messageLabel.text = "Relogging in!"
                    
                    //Relogging in
                    
                    self.loginToTow()
                    
                }
                
            }
            
        }
        
        log?.debug("Finished!")

    }
}
