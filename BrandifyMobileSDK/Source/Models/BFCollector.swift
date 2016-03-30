//
//  BFCollector.swift
//  Brandify iOS SDK
//

import Foundation

enum BFCollectorEventType : String
{
    
    case Unspecified = "Unspecified",
    LaunchApplication = "LaunchApplication",
    EnterBeaconZone = "EnterBeaconZone",
    ExitBeaconZone = "ExitBeaconZone",
    OpenLandingPage = "OpenLandingPage",
    UpdateLocation = "UpdateLocation",
    Some = "Some"
}

class BFCollector : BFBaseModel
{
    var deviceId : String?
    var deviceUUID : String?
    var beaconUUID : String?
    var beaconMajor : String?
    var beaconMinor : String?
    var pushToken : String?
    var eventType : BFCollectorEventType = BFCollectorEventType.Unspecified
    var longitude : Float?
    var latitude: Float?
    var appKey : String?
    var clientKey : String?
    
    private var customProperties : NSDictionary = NSDictionary()
    
    override init()
    {
        super.init()
    }
    
    func getCustomProperty(propertyName : String) -> AnyObject?
    {
        var propertyValue : AnyObject? = nil
        
        if let val = customProperties[propertyName]
        {
            propertyValue = val
        }
        
        return propertyValue
    }
    
    override func readFromJSONDictionary(jsonDict:NSDictionary!)
    {
        super.readFromJSONDictionary(jsonDict)
        
        let brandifyResponse = jsonDict["BrandifyResponse"]
        if(brandifyResponse != nil)
        {
            let response = brandifyResponse!["response"]
            if response != nil
            {
                let collector = response as! NSDictionary
                
                if let deviceId = collector["DeviceId"] as? String
                {
                    self.deviceId = deviceId
                }
                if let deviceUUID = collector["DeviceUUID"] as? String
                {
                    self.deviceUUID = deviceUUID
                }
                if let beaconUUID = collector["BeaconUUID"] as? String
                {
                    self.beaconUUID = beaconUUID
                }
                if let beaconMinor = collector["BeaconMinor"] as? String
                {
                    self.beaconMinor = beaconMinor
                }
                if let beaconMajor = collector["BeaconMajor"] as? String
                {
                    self.beaconMajor = beaconMajor
                }
                if let pushToken = collector["PushToken"] as? String
                {
                    self.pushToken = pushToken
                }
                if let eventType = collector["EventType"] as? BFCollectorEventType
                {
                    self.eventType = eventType
                }
                if let latitude = collector["Latitude"] as? Float
                {
                    self.latitude = latitude
                }
                if let longitude = collector["Longitude"] as? Float
                {
                    self.longitude = longitude
                }
                if let appKey = collector["AppKey"] as? String
                {
                    self.appKey = appKey
                }
                if let clientKey = collector["ClientKey"] as? String
                {
                    self.clientKey = clientKey
                }
                
                self.customProperties = collector
            }
        }
    }

    //Returns the Request in JSON format (not a true representation of the model)
    override func getJSONDictionaryString() -> NSString
    {
                
        let dictionary:NSDictionary = getJSONDictionary()
        
        var result: NSData?
        
        do {
            
            result = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
            
        }
        catch
        {
            
            print("BFCollector getJSONDictionaryString() - Could not serialize")
            
        }
        
        var jsonString:NSString = ""
        
        if result != nil
        {
            jsonString = NSString(data:result!, encoding : NSUTF8StringEncoding)!
            
        }
        
        return jsonString
    }
    
    func getJSONDictionary() -> NSDictionary
    {
        let dictionary : NSMutableDictionary = NSMutableDictionary()
        
       
        if let deviceId = self.deviceId
        {
            dictionary.setObject(deviceId, forKey: "DeviceId")
        }
        if let deviceUUID = self.deviceUUID
        {
            dictionary.setObject(deviceUUID, forKey: "DeviceUUID")
        }
        if let beaconUUID = self.beaconUUID
        {
            dictionary.setObject(beaconUUID, forKey: "BeaconUUID")
        }
        if let beaconMinor = self.beaconMinor
        {
            dictionary.setObject(beaconMinor, forKey: "BeaconMinor")
        }
        if let beaconMajor = self.beaconMajor
        {
            dictionary.setObject(beaconMajor, forKey: "BeaconMajor")
        }
        if let pushToken = self.pushToken
        {
            dictionary.setObject(pushToken, forKey: "PushToken")
        }
        if let longitude = self.longitude
        {
            dictionary.setObject(longitude, forKey: "Longitude")
        }
        if let latitude = self.latitude
        {
            dictionary.setObject(latitude, forKey: "Latitude")
        }
        if let appKey = self.appKey
        {
            dictionary.setObject(appKey, forKey: "AppKey")
        }
        if let clientKey = self.clientKey
        {
            dictionary.setObject(clientKey, forKey: "ClientKey")
        }
        
        dictionary.setObject(eventType.rawValue, forKey: "EventType")
        
        return dictionary
    }
}

