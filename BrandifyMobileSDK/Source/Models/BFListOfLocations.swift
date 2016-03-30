//
//  BFListOfLocations.swift
//  Brandify iOS SDK
//
//  Created by Frank Ayars on 12/21/15.
//  Copyright © 2015 Brandify. All rights reserved.
//

import Foundation

public class BFListOfLocations : BFBaseModel
{
    public var locationList = Array<BFLocation!>()
    public var latitutude : Float?
    public var longitude : Float?
    public var country : String?
    public var radius : Float?
    public var radiusuom : UnitOfMeasure?
    public var state : String?
    public var city : String?
    public var address : String?
    public var postalcode : String?
    public var province : String?
    public var responseCode : Int?
    
    override init()
    {
        super.init()
    }
    
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
    
    override func readFromJSONDictionary(jsonDict: NSDictionary!)
    {
        super.readFromJSONDictionary(jsonDict)
        
        if let brandifyResponse = jsonDict["BrandifyResponse"] as? NSDictionary
        {
            if let responseCode = brandifyResponse["code"] as? Int
            {
                self.responseCode = responseCode
                if(responseCode == 1)
                {
                    if let response = brandifyResponse["response"] as? NSDictionary
                    {
                        if let attributes = response["attributes"] as? NSDictionary
                        {
                            if let centerPoint = attributes["centerpoint"] as? String
                            {
                                let coords = centerPoint.componentsSeparatedByString(",")
                                if(coords.count > 1)
                                {
                                    longitude = Float(coords[0])
                                    latitutude = Float(coords[1])
                                }
                            }
                            
                            if let country = attributes["country"] as? String
                            {
                                self.country = country
                            }
                            
                            if let address = attributes["address"] as? String
                            {
                                self.address = address
                            }
                            
                            if let city = attributes["city"] as? String
                            {
                                self.city = city
                            }
                            
                            if let state = attributes["state"] as? String
                            {
                                self.state = state
                            }
                            
                            if let postalcode = attributes["postalcode"] as? String
                            {
                                self.postalcode = postalcode
                            }
                            
                            if let province = attributes["province"] as? String
                            {
                                self.province = province
                            }
                            
                            if let radius = attributes["radius"] as? Float
                            {
                                self.radius = radius
                            }
                            
                            if let radiusuomString = attributes["radius"] as? String
                            {
                                switch(radiusuomString)
                                {
                                case "mile":
                                    self.radiusuom = UnitOfMeasure.Miles
                                    break;
                                case "KM":
                                    self.radiusuom = UnitOfMeasure.Kilometers
                                    break;
                                case "meter":
                                    self.radiusuom = UnitOfMeasure.Meters
                                    break;
                                default:
                                    self.radiusuom = UnitOfMeasure.Miles
                                    break;
                                }
                            }
                            
                            self.customProperties = attributes
                        }
                        
                        var sequence : Int = 0
                        if let locations: NSArray = response["collection"] as? NSArray
                        {
                            if locations.count > 0
                            {
                                for location in locations
                                {
                                    let aLocation: BFLocation = BFLocation()
                                    
                                    let responseDict = ["response" : location] as NSDictionary
                                    let locationDict = ["Status" : jsonDict["Status"] as! NSDictionary, "BrandifyResponse" : responseDict] as NSDictionary
                                    
                                    aLocation.sequence = sequence
                                    aLocation.readFromJSONDictionary(locationDict)
                                    locationList.append(aLocation)
                                    
                                    sequence++
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}