//
//  BFContext.swift
//  Brandify iOS SDK
//


import Foundation

public class BFContext : NSObject
{
    
    var restURL : String = String()
    let collectorRestURL = "http://collector.brandify.com/rest/collector"
    var apiKey : String = String()
    
    public override init()
    {
        super.init()
        
        let brandifyConfigurationDP = BFConfigurationDP()
        let brandifyConfiguration = brandifyConfigurationDP.getConfiguration(false)
        
        restURL = brandifyConfiguration.locatorSearchRestURL!
        apiKey = brandifyConfiguration.appkey!
    }
    
}