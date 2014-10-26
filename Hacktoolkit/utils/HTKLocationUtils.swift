//
//  HTKLocationUtils.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation
import CoreLocation

let htkDidUpdateLocationNotification = "htkDidUpdateLocationNotification"

class HTKLocationUtils: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var mostRecentLocation: CLLocation?

    class var sharedInstance : HTKLocationUtils {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : HTKLocationUtils? = nil
        }
        dispatch_once(&Static.token) {
            Static.instance = HTKLocationUtils()
        }
        return Static.instance!
    }

    override init() {
        locationManager = CLLocationManager()
    }

    func startMonitoringLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        //locationManager.stopUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location = locations[0] as CLLocation
        mostRecentLocation = location
        NSNotificationCenter.defaultCenter().postNotificationName(
            htkDidUpdateLocationNotification,
            object: nil,
            userInfo: ["location" : location]
        )
    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            println("Error : \(error)")
        }
    }
}
