//
//  BFMobileSDK.swift
//  BrandifyMobileSDK
//
//  Created by Frank Ayars on 1/15/16.
//  Copyright © 2016 Brandify. All rights reserved.
//

import Foundation
import CoreLocation

public class BFMobileSDK
{
    
    private static var locationCollector : LocationCollector?
    
    public static func initialize()
    {
        locationCollector = LocationCollector()

        let brandifyConfigurationDP : BFConfigurationDP = BFConfigurationDP()
        brandifyConfigurationDP.getConfiguration(true)
        
        //send information to the analytics engine
        let context = BFContext()
        let brandifyCollectorDP = BFCollectorDP()
        let brandifyCollector = BFCollector()
        
        brandifyCollector.eventType = .LaunchApplication
        brandifyCollector.deviceId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        
        brandifyCollectorDP.saveEvent(context, collector: brandifyCollector) { (BFCollector) -> () in
            
        }

    }
    
    
}

class LocationCollector : NSObject, CLLocationManagerDelegate
{
    private var locManager: CLLocationManager?
    
    override init()
    {
        super.init()
        
        locManager = CLLocationManager()
        //number of meters before update is triggered...
        locManager?.distanceFilter = 1200 //roughly half of a mile
        locManager?.delegate = self
        locManager?.desiredAccuracy = kCLLocationAccuracyBest
        locManager?.requestAlwaysAuthorization()
        locManager?.startUpdatingLocation()
    }
    
    //MARK: LocationManager Delegates
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        print("BFMobileSDK.locationManager:didUpdateLocations(): did update Location")
        
        let location = locations.last
        
        //send information to the analytics engine
        let context = BFContext()
        let brandifyCollectorDP = BFCollectorDP()
        let brandifyCollector = BFCollector()
        
        brandifyCollector.eventType = .UpdateLocation
        brandifyCollector.deviceId = UIDevice.currentDevice().identifierForVendor?.UUIDString
        brandifyCollector.latitude = Float(location!.coordinate.latitude)
        brandifyCollector.longitude = Float(location!.coordinate.longitude)
        
        brandifyCollectorDP.saveEvent(context, collector: brandifyCollector) { (BFCollector) -> () in
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        print("BFMobileSDKlocationManager:didEnterRegion():did enter region")
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        print("BFMobileSDK.locationManager:didExitRegion(): did exit region")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("BFMobileSDK.locationManager:didFailWithError(): \(error)")
    }
}