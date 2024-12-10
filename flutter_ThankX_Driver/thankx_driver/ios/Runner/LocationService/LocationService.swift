//
//  LocationService.swift
//  Youfie
//
//  Created by Dhaval Patel on 11/07/16.
//  Copyright © 2016 Agile InfoWays. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public enum LocationState {
    case authorizedAlways, authorizedWhenInUse, retricted, failed ,notDetermined, denied
}


let AppLocationManager = LocationService.sharedManager

class LocationService: NSObject {

    internal typealias locationHandler = ((CLLocationCoordinate2D?,LocationState) -> Void)?
    
    fileprivate var locationManager: CLLocationManager?
    
    fileprivate var locationCompletion: locationHandler = nil
    fileprivate var curruntTimeStamp = 0.0
    
    var onListenLocationPermissionStateChange: ((LocationState) -> Void)? = nil
    
    // this variable used for currunt starting ride
    var isAllowContinuesLocationUpdate: Bool = false {
        didSet {
            if isAllowContinuesLocationUpdate {
                if self.isAllowContinuesLocationUpdate {
                    self.locationManager?.requestAlwaysAuthorization()
                }
                self.curruntTimeStamp = Date().timeIntervalSince1970
                self.locationManager?.startUpdatingLocation()
            }
        }
    }
    
    //MARK:- SHAREDMANAGER
    static let sharedManager : LocationService = {
        let instance = LocationService()
        return instance
    }()
    
    
    internal var serviceState: LocationState {
        guard CLLocationManager.locationServicesEnabled() else {
            return .retricted
        }
        var state: LocationState = .notDetermined
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            state = .notDetermined
            break
        case .denied:
            state = .denied
            break
        case .authorizedAlways:
            state = .authorizedAlways
            break
        case .authorizedWhenInUse:
            state = .authorizedWhenInUse
            break
        default:
            break
        }
        return state
    }

    func stopLocationUpdating() -> Swift.Void {
        self.isAllowContinuesLocationUpdate = false
        self.locationManager?.stopUpdatingLocation()
    }
    
    
    func getLocation(isAskForContinousLocation: Bool = false ,completionHandler: locationHandler) -> Void {
        
        self.curruntTimeStamp = Date().timeIntervalSince1970
        self.locationCompletion = completionHandler
        self.isAllowContinuesLocationUpdate = isAskForContinousLocation
        if let locationManager = self.locationManager {
            if isAskForContinousLocation {
                locationManager.requestAlwaysAuthorization()
            }
            else {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.startUpdatingLocation()
        }
    }
    
    override init() {
        super.init()
        self.intializeLocationManager()
    }
    
    internal func intializeLocationManager() {
        if let locationManager = self.locationManager {
            locationManager.delegate = nil
        }
        self.locationManager = nil
        
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.distanceFilter = kCLDistanceFilterNone
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
        if #available(iOS 9.0, *) {
            self.locationManager?.allowsBackgroundLocationUpdates = true
        } else {
            // Fallback on earlier versions
        }
        self.locationManager?.pausesLocationUpdatesAutomatically = false
    }
}



extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if let onListenLocationPermissionStateChange = self.onListenLocationPermissionStateChange {
            onListenLocationPermissionStateChange(self.serviceState)
        }
        
        switch status {
        case .restricted, .denied:
            if let validCompetionHandler = self.locationCompletion {
                validCompetionHandler(nil, self.serviceState)
            }
            self.locationCompletion = nil
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        //Notify Contiuous location update -- used when all update of location require

        if isAllowContinuesLocationUpdate, let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.lastCoordinate = location.coordinate
            AppSocketManager.shared.logDriverLocationInFile(withCoordinate: location.coordinate)
        }
        if (self.curruntTimeStamp != Date().timeIntervalSince1970) {
            if let locationCompletion = self.locationCompletion{ // Inside Whwn from get location call
                locationCompletion(location.coordinate, self.serviceState)
            }
            self.locationCompletion = nil
            
            if !isAllowContinuesLocationUpdate {
                self.locationManager?.stopUpdatingLocation()
            }
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        "Error :: \(error.localizedDescription)".performLog()
        
        if (error as NSError).code == 0 {
            //notify handler
            if let locationCompletion = self.locationCompletion {
                locationCompletion(nil, self.serviceState)
            }
            self.locationCompletion = nil
            return
        }
        
        if let locationCompletion = self.locationCompletion {
            locationCompletion(nil, self.serviceState)
        }
        self.locationCompletion = nil
    }
}
