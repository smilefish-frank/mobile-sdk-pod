//
//  BFLocatorDP.swift
//  Brandify iOS SDK
//

import Foundation

public class BFLocatorDP : NSObject
{
    
    public override init()
    {
        super.init()
    }

   public func search(context:BFContext, searchLocation:BFSearchLocation, completionBlock:(returnListOfLocations: BFListOfLocations) -> ())
   {
        let connection:BFConnection = BFConnection()

        searchLocation.securityContext.apiKey = context.apiKey;
    
        connection.ajax(context.restURL, verb: "POST", requestBody: searchLocation)
        {
            (jsonDict) -> () in

                let listOfLocations : BFListOfLocations = BFListOfLocations()

                listOfLocations.readFromJSONDictionary(jsonDict as! NSDictionary)

                completionBlock(returnListOfLocations : listOfLocations)
        }
    }
}
