//
//  BFLocation.swift
//  Brandify iOS SDK
//

import Foundation

public class BFLocation : BFBaseModel
{
    
    public var sequence : Int!
    
    // store locations
    public var name: String?
    public var address1: String?
    public var address2: String?
    public var city: String?
    public var state: String?
    public var postalcode: String?
    public var province: String?
    public var country: String?
    public var phone: String?
    public var icon: String?
    
    //shared
    public var longitude : Double? = 0.0
    public var latitude : Double? = 0.0
    public var distance : String? = "0.0"
    public var storeImageURL : String?
    public var clientKey : String?
    
    public var mapPinURL : String?
    
    public var images : Array<String> = []
    
    private var customProperties : NSDictionary = NSDictionary()
    
    public func getCustomProperty(propertyName : String) -> AnyObject?
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
                let brandifyConfigurationDP : BFConfigurationDP = BFConfigurationDP()
                let brandifyConfiguration : BFConfiguration = brandifyConfigurationDP.getConfiguration(false);
                
                let location = response as! NSDictionary
               
                let longitude = location["longitude"]
                let latitude = location["latitude"]
                self.longitude = longitude?.doubleValue
                self.latitude = latitude?.doubleValue
                self.name = location["name"] as? String
                self.address1 = location["address1"] as? String
                self.address2 = location["address2"] as? String
                self.city = location["city"] as? String
                self.state = location["state"] as? String
                self.postalcode = location["postalcode"] as? String
                self.province = location["province"] as? String
                self.phone = location["phone"] as? String
                self.distance = location["_distance"] as? String
                self.icon = location["icon"] as? String
                
                if let defaultStoreImagePathURL = brandifyConfiguration.defaultStoreImagePathURL
                {
                    self.storeImageURL = defaultStoreImagePathURL
                }
                
                if let clientKey = location["clientkey"]
                {
                    self.clientKey = clientKey as? String
                    
                    if let baseImagePathURL = brandifyConfiguration.baseStoreImagePathURL
                    {
                        self.storeImageURL = baseImagePathURL + self.clientKey! + "-1-s.jpg";
                    }
                }

                for i in 1...10
                {
                    if let image = location["image" + String(i)] as? String
                    {
                        self.images.append(image)
                    }
                }
                
                var iconKey = "default"
                if let locationIconKey = self.icon
                {
                    iconKey = locationIconKey
                }
                
                if(brandifyConfiguration.icons != nil)
                {
                    if let mapPinURLString = brandifyConfiguration.icons?[iconKey] as? String
                    {
                        self.mapPinURL = mapPinURLString
                    }
                }
                
                self.customProperties = location
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
            
            print("BFLocation getJSONDictionaryString() - Could not serialize")
            
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
        
       
        if let locationName = self.name
        {
            dictionary.setObject(locationName, forKey: "LocationName")
        }
        
        if let streetAddress = self.address1
        {
            dictionary.setObject(streetAddress, forKey: "Address1")
        }
        
        if let streetAddress2 = self.address2
        {
            dictionary.setObject(streetAddress2, forKey: "Address2")
        }
        
        if let latitude = self.latitude
        {
            dictionary.setObject(latitude, forKey: "Latitude")
        }
        
        if let longitude = self.longitude
        {
            dictionary.setObject(longitude, forKey: "Longitude")
        }
        
        if let city = self.city
        {
            dictionary.setObject(city, forKey: "City")
        }
        
        if let state = self.state
        {
            dictionary.setObject(state, forKey: "State")
        }
        
        if let postalcode = self.postalcode
        {
            dictionary.setObject(postalcode, forKey: "Postalcode")
        }
        
        if let province = self.province
        {
            dictionary.setObject(province, forKey: "Province")
        }
        
        if let distance = self.distance
        {
            dictionary.setObject(distance, forKey: "Distance")
        }
        
        if let icon = self.icon
        {
            dictionary.setObject(icon, forKey: "Icon")
        }
        
        if let phone = self.phone
        {
            dictionary.setObject(phone, forKey: "Phone")
        }
        
        return dictionary
    }

}

