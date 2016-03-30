//
//  BFSearchLocation.swift
//  Brandify iOS SDK
//

import Foundation

public enum UnitOfMeasure
{
    case Miles
    case Meters
    case Kilometers
}

public class BFSearchLocation : BFBaseModel
{
    public var name: String?
    public var addressLine: String? = ""
    public var country: String? = ""
    public var longitude : Float? = 0.0
    public var latitude : Float? = 0.0
    
    public var geoip : Bool? = true
    
    //hide for now: private var whereString : String? = nil
    
    public var searchradius = [15,30,60,120]
    private var searchRadiusString : String = ""
    
    public var radiusUOM : UnitOfMeasure? = nil
    
    public var limit : Int = 250
    
    public var filterProperties = NSMutableDictionary()
    
    public override init()
    {
        super.init()
    }
    
    //Returns the Request in JSON format (not a true representation of the model)
    override func getJSONDictionaryString() -> NSString
    {
       
        let brandifyConfigurationDP : BFConfigurationDP = BFConfigurationDP()
        let brandifyConfiguration = brandifyConfigurationDP.getConfiguration(false)
        
        var rUOM = brandifyConfiguration.locator.formdata.radiusUOM
        
        //if client has provided a value...override default
        if radiusUOM != nil
        {
            switch(radiusUOM!)
            {
            case UnitOfMeasure.Miles:
                rUOM = "mile"
                break;
            case UnitOfMeasure.Kilometers:
                rUOM = "KM"
                break;
            case UnitOfMeasure.Meters:
                rUOM = "meter"
                break;
            }
        }
        //default
        searchRadiusString = brandifyConfiguration.locator.formdata.searchRadius
        
        //if list exists, override default...
        if(searchradius.count > 0)
        {
            searchradius.sortInPlace()
            searchRadiusString = ""
            var pipeString = ""
            for currentRadius:Int in searchradius
            {
                searchRadiusString = searchRadiusString + pipeString + String(currentRadius)
                pipeString = "|"
            }
        }
        
        //default where
        let whereString : String? = brandifyConfiguration.locator.formdata.whereString
       
        if addressLine! != "" || (longitude != 0 && latitude != 0)
        {
            geoip? = false
        }
        
        var jsonDict =  [
            "request":
            [
                "appkey": securityContext.apiKey!,
                "formdata":
                [
                    "dataview": "store_default",
                    "limit": limit,
                    "geolocs":
                    [
                        "geoloc":
                        [
                            [
                                "addressline": addressLine!,
                                "country": country!,
                                "latitude": latitude!,
                                "longitude": longitude!
                            ]
                        ]
                    ],
                    "searchradius" : searchRadiusString,
                    "radiusuom" : rUOM
                ],
                "geoip": geoip!
            ]
        ]
        
        //append the where clause - if one exists
        if(whereString != nil)
        {
            if let data = whereString!.dataUsingEncoding(NSUTF8StringEncoding)
            {
                do
                {
                    let whereDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSMutableDictionary
                    
                    for key in filterProperties.allKeys
                    {
                        if let keyString = key as? String
                        {
                            let val = filterProperties[keyString]
                            setWhereValue(whereDict!, propertyName: keyString, propertyValue: val!)
                        }
                    }
                    
                    var formdataDict = jsonDict["request"]!["formdata"] as! Dictionary<String, AnyObject>
                    formdataDict["where"] = whereDict
                    jsonDict["request"]!["formdata"] = formdataDict
                }
                catch
                {
                    
                }
            }
        }
        
        var json :NSString = NSString(string: "")
        do
        {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDict, options: NSJSONWritingOptions(rawValue: 0))
            json = NSString(data: jsonData, encoding: NSASCIIStringEncoding)!
        }
        catch
        {
            
        }
        
        print(json)
        return json
        
    }
    
    func setWhereValue(dict : NSMutableDictionary, propertyName : String, propertyValue : AnyObject)
    {
        if let _ = dict[propertyName]
        {
            if let propValDict = dict[propertyName] as? NSMutableDictionary
            {
                if(propValDict.count > 0)
                {
                    if let key : String? = propValDict.allKeys[0] as? String
                    {
                        propValDict[key!] = String(propertyValue)
                        print("setting " + propertyName + ": " + String(propertyValue))
                    }
                }
            }
        }
        else
        {
            //look in child collections
            for dictValue in dict.allValues
            {
                if let childValue = dictValue as? NSMutableDictionary
                {
                    setWhereValue(childValue, propertyName: propertyName, propertyValue: propertyValue)
                }
            }
        }
    }

}

