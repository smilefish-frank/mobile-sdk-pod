//
//  BFCollectorDP.swift
//  Brandify iOS SDK

import Foundation

class BFCollectorDP: NSObject
{
    
    override init()
    {
        super.init()
    }

    func saveEvent(context:BFContext, collector: BFCollector, completion:(BFCollector) -> ())
    {
        
        let connection:BFConnection = BFConnection()
        
        //let userDP : SFLUserDP = SFLUserDP()
        
        let dump = BFCollectorDump()
        collector.appKey = context.apiKey
        dump.data = collector.getJSONDictionaryString() as String
        
        collector.securityContext.apiKey = context.apiKey
        //collector.securityContext.authToken = userDP.getSerializedAuthToken() as String
        
        connection.ajax(context.collectorRestURL, verb: "POST", requestBody: collector) { (jsonDict) -> () in
            
            let returnedCollector = BFCollector()
            
            if jsonDict != nil
            {
                
                returnedCollector.readFromJSONDictionary(jsonDict as! NSDictionary)
                
            }
            
            completion(returnedCollector)
            
        }
        
    }
}