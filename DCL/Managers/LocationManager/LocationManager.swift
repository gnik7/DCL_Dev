//
//  LocationManager.swift
//  DCL
//
//  Created by Nikita on 2/16/17.
//  Copyright © 2017 Nikita. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(_ locationManager: LocationManager, getAuthorization status: CLAuthorizationStatus)
}

class LocationManager: NSObject {
    
    static let sharedInstance = LocationManager()
    
    var locationManager: CLLocationManager!
    weak var delegate: LocationManagerDelegate?
    var complitionHandler   : ((CLLocation) -> ())?
    
    func initLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func startLocationManager() {
        self.locationManager.startUpdatingLocation()
    }

    
    func stopLocationManager() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func updateCoordinates(action: ((CLLocation) -> ())?) {
        complitionHandler = action
    }
    
    static func updateCurrentLocationAddress(location : CLLocation , completed: @escaping (String) -> ())  {
        var address = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks , error) in
            if error == nil && (placemarks?.count)! > 0 {
                let location = placemarks![0] as CLPlacemark
                address = "\(String(describing: location.locality)) \(String(describing: location.thoroughfare)) \(String(describing: location.subThoroughfare))  \(String(describing: location.country))"
                guard let state = location.administrativeArea as String?,
                    let streetName = location.thoroughfare as String?,
                    let streetNumber = location.subThoroughfare as String?,
                    let city = location.locality as String? else {
                        completed("")
                        return
                }
                
                address = streetName + ", " + streetNumber + " " + city + " " + state
                completed(address)
            }
        })
    }
}

extension  LocationManager: CLLocationManagerDelegate {
    
    //*****************************************************************
    // MARK: - CLLocationManagerDelegate
    //*****************************************************************
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let location = locationArray.lastObject as! CLLocation

        if let action = complitionHandler {
            action(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("restricted")
            break
        case .denied:
            delegate?.locationManager(self, getAuthorization: status)
            break
        case .notDetermined:
            print("notDetermined")
            delegate?.locationManager(self, getAuthorization: status)
            break
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            break
        }
    }

}
