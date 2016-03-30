//
//  Configuration.swift
//  Brandify iOS SDK
//
//  Created by Frank Ayars on 12/11/15.
//  Copyright © 2015 Smilefish Corporation. All rights reserved.
//

import Foundation


public class GeolocsConfig
{
    public var geolocs:[GeolocConfig] = []
    
    func readFromJSONDictionary(dictionary:NSDictionary)
    {
        
        geolocs = GeolocConfig.readArray(dictionary["geoloc"] as! [NSArray])
    }
    
    class func readArray(array:NSArray) -> [GeolocsConfig]
    {
        var result:[GeolocsConfig] = []
        for item in array
        {
            let newItem = GeolocsConfig()
            newItem.readFromJSONDictionary(item as! NSDictionary)
            result.append(newItem)
        }
        return result
    }
    
}

public class FormdataConfig
{
    public var geoip:Bool = true
    public var dataview:String = "store_default"
    public var limit:Int = 250
    public var geolocs:GeolocsConfig = GeolocsConfig()
    public var searchRadius:String = "10|25|50|100|250"
    public var radiusUOM : String = "mile"
    public var order:String = "_DISTANCE DESC"
    public var whereString : String = ""
    
    func readFromJSONDictionary(dictionary:NSDictionary)
    {
        
        if let geoip = dictionary["geoip"] as? Bool
        {
            self.geoip = geoip
        }
        
        if let dataview = dictionary["dataview"] as? String
        {
            self.dataview = dataview
        }
        
        if let limit = dictionary["limit"] as? Int
        {
            self.limit = limit
        }
        
        if let dict = dictionary["geolocs"] as? NSDictionary
        {
            geolocs.readFromJSONDictionary(dict)
        }
        
        if let searchRadius = dictionary["searchradius"] as? String
        {
            self.searchRadius = searchRadius
        }
        
        if let order = dictionary["order"] as? String
        {
            self.order = order
        }
        
        if let radiusuom = dictionary["radiusuom"] as? String
        {
            self.radiusUOM = radiusuom
        }
        
        if let whereDict : NSDictionary = dictionary["where"] as? NSDictionary
        {
            var result: NSData? = nil
            do
            {
                
                result = try NSJSONSerialization.dataWithJSONObject(whereDict, options: NSJSONWritingOptions.PrettyPrinted)
                
            }
            catch
            {
                
                print("BFConfiguration.Formdata.readFromDictioinaryString() - Could not serialize JSON")
                
            }
            
            if result != nil
            {
                whereString = String(data:result!, encoding : NSUTF8StringEncoding)!
            }
        }
    }
}

public class GeolocConfig
{
    public var addressLine:String=""
    public var address1:String = ""
    public var country:String = ""
    public var latitude:String = ""
    public var longitude:String = ""
    
    func readFromJSONDictionary(dictionary:NSDictionary)
    {
        if let addressLine = dictionary["addressLine"] as? String
        {
            self.addressLine = addressLine
        }
        
        if let country = dictionary["country"] as? String
        {
            self.country = country
        }
        
        if let latitude = dictionary["latitude"] as? String
        {
            self.latitude = latitude
        }
        
        if let longitude = dictionary["longitude"] as? String
        {
            self.longitude = longitude
        }

    }
    
    class func readArray(array:NSArray) -> [GeolocConfig]
    {
        var result:[GeolocConfig] = []
        for item in array
        {
            let newItem = GeolocConfig()
            newItem.readFromJSONDictionary(item as! NSDictionary)
            result.append(newItem)
        }
        return result
    }
    
}

public class LocatorConfig
{
    public var formdata:FormdataConfig = FormdataConfig()
    
    func readFromJSONDictionary(dictionary:NSDictionary)
    {
        if let dict = dictionary["formdata"] as? NSDictionary
        {
            formdata.readFromJSONDictionary(dict)
        }
    }
    
    class func readArray(array:NSArray) -> [LocatorConfig]
    {
        var result:[LocatorConfig] = []
        for item in array
        {
            let newItem = LocatorConfig()
            newItem.readFromJSONDictionary(item as! NSDictionary)
            result.append(newItem)
        }
        return result
    }
    
}

public class BFConfiguration
{
    public var appkey : String?
    public var locatorSearchRestURL : String?
    public var netconfig : String?
    public var autoStart : Bool = false
    public var locator:LocatorConfig = LocatorConfig()
    public var icons : NSDictionary?
    public var logos : NSDictionary?
    public var baseStoreImagePathURL : String?
    public var defaultStoreImagePathURL : String?
    public var sendToEmailImagePathURL : String?
    public var sendToPhoneImagePathURL : String?
    
    public var panMilesBeforeRefresh : Double?
    
    func readFromJSONDictionary(dictionary:NSDictionary)
    {
        if let config = dictionary["config"] as? NSDictionary
        {
            if let appkey = config["appkey"] as? String
            {
                self.appkey = appkey
            }
            
            if let locatorSearchRestURL = config["locatorSearchRestURL"] as? String
            {
                self.locatorSearchRestURL = locatorSearchRestURL
            }
            
            if let netconfig = config["netconfig"] as? String
            {
                self.netconfig = netconfig
            }
            
            if let autoStart = config["autoStart"] as? Bool
            {
                self.autoStart = autoStart
            }
            
            if let icons = config["icons"] as? NSDictionary
            {
                self.icons = icons
            }
            
            if let logos = config["logos"] as? NSDictionary
            {
                self.logos = logos
            }
            
            if let baseStoreImagePathURL = config["baseStoreImagePathURL"] as? String
            {
                self.baseStoreImagePathURL = baseStoreImagePathURL
            }
            
            if let defaultStoreImagePathURL = config["defaultStoreImagePathURL"] as? String
            {
                self.defaultStoreImagePathURL = defaultStoreImagePathURL
            }
            
            if let sendToEmailImagePathURL = config["sendToEmailImagePathURL"] as? String
            {
                self.sendToEmailImagePathURL = sendToEmailImagePathURL
            }
            
            if let sendToPhoneImagePathURL = config["sendToPhoneImagePathURL"] as? String
            {
                self.sendToPhoneImagePathURL = sendToPhoneImagePathURL
            }
            
            if let panMilesBeforeRefresh = config["panMilesBeforeRefresh"] as? Double
            {
                self.panMilesBeforeRefresh = panMilesBeforeRefresh
            }
            
            if let dict = config["locator"] as? NSDictionary
            {
                locator.readFromJSONDictionary(dict)
            }
        }
    }
    
    class func DateFromString(dateString:String) -> NSDate
    {
        let dateFormatter = NSDateFormatter()
        let enUSPosixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter.dateFromString(dateString)!
    }
}

