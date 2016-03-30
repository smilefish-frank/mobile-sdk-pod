//
//  BFConfigurationDP.swift
//  BrandifySDKDemo
//
//  Created by Frank Ayars on 12/14/15.
//  Copyright © 2015 Smilefish Corporation. All rights reserved.
//

import Foundation

public class BFConfigurationDP : NSObject
{
    public func getConfiguration(forceRefresh : Bool) -> BFConfiguration
    {
        let brandifyConfiguration : BFConfiguration = BFConfiguration()
        
        //always fall back to known disk config file
        let configPath : String = NSBundle.mainBundle().pathForResource("sdkconfig", ofType: "json")!
        if let jsonData = NSData(contentsOfFile: configPath)
        {
            do
            {
                if let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                {
                    brandifyConfiguration.readFromJSONDictionary(jsonResult)
                }
            }
            catch
            {
                print("Error deserializing JSON string from disk config file.")
            }
        }
        
        var cachesConfigPath : String?
        var netConfigPath : String?
        let fileManager = NSFileManager.defaultManager()
        
        var paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        if paths.count > 0
        {
            cachesConfigPath = paths[0] + "/sdkconfig.json"
        }
        
        paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if paths.count > 0
        {
            netConfigPath = paths[0] + "/netconfig"
        }
        
        var netconfig : String?
        //first check the docs folder for netconfig file (this takes precendence over the disk netconfig value)
        if(fileManager.fileExistsAtPath(netConfigPath!) == true)
        {
            if let netconfigData = NSData(contentsOfFile: netConfigPath!)
            {
                netconfig = String(data: netconfigData, encoding: NSUTF8StringEncoding)
            }
        }
        
        if(netconfig != nil)
        {
            //fix the in-memory configuration with the overriden netconfig value
            brandifyConfiguration.netconfig = netconfig
        }
        
        //get cached config file, unless 'forceRefresh' flag is set
        if(forceRefresh == true)
        {
            do
            {
                if(fileManager.fileExistsAtPath(cachesConfigPath!) == true)
                {
                    try fileManager.removeItemAtPath(cachesConfigPath!)
                }
                //ensure that caches path always has a config file (if net fails or doesn't exist
                try fileManager.copyItemAtPath(configPath, toPath: cachesConfigPath!)
            }
            catch
            {
                print("Error copying config from bundle to caches directory.")
            }
            
            //get default config data
    
            if let jsonData = NSData(contentsOfFile: cachesConfigPath!)
            {
                do
                {
                    if let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    {
                        brandifyConfiguration.readFromJSONDictionary(jsonResult)
                        
                        //defaults are now set, check for config on the net
                        
                        //if could not get netconfig url from disk file, get from default config
                        if netconfig == nil
                        {
                            netconfig = brandifyConfiguration.netconfig
                        }
                            
                        if netconfig != nil
                        {
                            //make sure the in-memory configuration has the most accurate netconfig value
                            brandifyConfiguration.netconfig = netconfig
                            
                            let netConfigURL = NSURL(string: netconfig!)
                            
                            let netConfigData = NSData(contentsOfURL: netConfigURL!)
                            
                            if(netConfigData != nil)
                            {
                                do
                                {
                                    netConfigData!.writeToFile(cachesConfigPath!, atomically: true)
                                    
                                    let netJSONResult = try NSJSONSerialization.JSONObjectWithData(netConfigData!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                                    
                                    //this will overwrite, but not remove existing when the netconfig propery is nil
                                    brandifyConfiguration.readFromJSONDictionary(netJSONResult)
                                }
                                catch
                                {
                                    print("Error deserializing JSON string from net config file.")
                                }
                            }
                            else
                            {
                                print("Unable to retrieve net config file.")
                            }
                        }
                    }
                }
                catch
                {
                    print("Error deserializing JSON string from net config file.")
                }
            }
        }
        else
        {
            if let jsonData = NSData(contentsOfFile: cachesConfigPath!)
            {
                do
                {
                    if let jsonResult: NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    {
                        brandifyConfiguration.readFromJSONDictionary(jsonResult)
                        
                        //ensure the in-memory configuration contains the most accurate netconfig value
                        if(netconfig != nil)
                        {
                            brandifyConfiguration.netconfig = netconfig
                        }
                    }
                }
                catch
                {
                    print("Error reading config data.")
                }
            }
        }
        
        return brandifyConfiguration
    }
    
    public func setNetConfig(netConfigURL: String)
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if paths.count > 0
        {
            let netConfigPath = paths[0] + "/netconfig"
            do
            {
                try netConfigURL.writeToFile(netConfigPath, atomically: true, encoding: NSUTF8StringEncoding)
            }
            catch
            {
                print("Error creating the netconfig file.")
            }
        }
    }
    
    public func clearNetConfig()
    {
        let fileManager = NSFileManager.defaultManager()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if paths.count > 0
        {
            do
            {
                let netConfigPath = paths[0] + "/netconfig"
                if(fileManager.fileExistsAtPath(netConfigPath) == true)
                {
                    try fileManager.removeItemAtPath(netConfigPath)
                }
            }
            catch
            {
                print("Error removing the netconfig file.")
            }
        }
    }
}