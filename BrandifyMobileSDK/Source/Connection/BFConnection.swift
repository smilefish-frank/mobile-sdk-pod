
//
//  SFLConnection.swift
//  SFLibrary
//
//  Created by Ralf Brockhaus on 3/6/15.
//  Copyright (c) 2015 Smilefish. All rights reserved.
//

import Foundation
import UIKit

public class BFConnection : NSObject, NSURLSessionDelegate, NSURLSessionDataDelegate
{
    
    var sharedSession: NSURLSession! = NSURLSession.sharedSession()
    var responseDATA = NSMutableData()
    var completion : (AnyObject!) -> () = { (obj) -> () in }
    
    public func ajax(url: NSString, verb: NSString, requestBody:BFBaseModel, completionBlock:(AnyObject!) -> ()) {
        
        // Initialize container for data collected from NSURLConnection
        
        let jsonRequest = requestBody.getJSONDictionaryString()
        
        let jsonData = NSData(bytes: jsonRequest.UTF8String, length: jsonRequest.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        let requestURL = NSURL(string: url as String)
        
        let request = NSMutableURLRequest(URL: requestURL!)
        
        DLog(NSString(format: " \n\n\nBFConnection.ajax:ver:requestbody:completionBlock() URL = %@ \nVERB = %@ \nREQUEST JSON = %@", requestURL!, verb, jsonRequest) as String)
        
        request.HTTPMethod = verb as String
        request.setValue("application/json; charset = utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = jsonData
        
        // create task
        let task = sharedSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
        
            if error != nil
            {
                
                // Pass the error from the connection to the completionBlock
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                let status = NSDictionary(objects: [NSNumber(int: 1), "The connection failed."], forKeys: ["Code", "Description"])
                
                let jsonDict = ["Status" : status] as NSDictionary
                
                dispatch_async(dispatch_get_main_queue())
                {
                
                    self.completion(jsonDict)
                    
                }
                
            }
            else
            {
            
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                let returnJSONString = NSString(data:data!, encoding:NSUTF8StringEncoding)
                
                DLog("SFLConnection.connectionDidFinishLoading(): URL: \(request.URL), VERB: \(request.HTTPMethod), responseJSON: \(returnJSONString)")
                
                var jsonDict: AnyObject?
                
                do
                {
                    
                    jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    
                }
                catch _
                {
                    
                    jsonDict = nil
                }
                
                if let theJSONString = jsonDict as? NSString
                {
                    
                    let status: NSDictionary = NSDictionary(objects: [NSNumber(int: 1), theJSONString], forKeys: ["Code", "Description"])
                    
                    jsonDict = ["Status" : [status]]
                    
                }
                else
                    if let theJSONDict = jsonDict as? NSDictionary
                    {
                        
                        // check for status object
                        
                        if theJSONDict["Status"] != nil
                        {
                            
                            jsonDict = theJSONDict as NSDictionary
                            
                        }
                            
                            // TODO: Review with Frank - reviewed it...take this else out after Frank fixes REST services
                            // If we cannot find a status object, check for base model
                            
                        else if  theJSONDict["Code"]  != nil
                        {
                            
                            let responseObject = BFBaseModel(JSONDictionary: ["Status" : theJSONDict])
                            
                            jsonDict = responseObject
                            
                            DLog("BFConnection.connectionDidFinishLoading() - Warning: Returned object has unexpected format.")
                            
                        }
                        else if theJSONDict["response"] != nil
                        {
                            //Brandify Response
                            let status: NSDictionary = NSDictionary(objects: [NSNumber(int: 0), "OK"], forKeys: ["Code", "Description"])
                            
                            jsonDict = ["Status" : status, "BrandifyResponse" : jsonDict!] as NSDictionary
                        }
                        else
                        {
                            
                            if let message: AnyObject = theJSONDict["Message"]
                            {
                                
                                DLog("error:" + (message as! String))
                                
                                let status = NSDictionary(objects: [NSNumber(int: 999), message], forKeys: ["Code", "Description"])
                                
                                jsonDict = ["Status" : status] as NSDictionary
                                
                            }
                            else
                            {
                                let status = NSDictionary(objects: [NSNumber(int: 1), "Unable to read the response."], forKeys: ["Code", "Description"])
                                
                                jsonDict = ["Status" : status] as NSDictionary
                            }
                            
                        }
                        
                    }
                    else
                    {
                        
                        let status = NSDictionary(objects: [NSNumber(int: 1), "No data returned from request."], forKeys: ["Code", "Description"])
                        
                        jsonDict = ["Status" : status] as NSDictionary
                        
                }
                
                dispatch_async(dispatch_get_main_queue())
                {
                
                    self.completion(jsonDict)
                
                }
                
            }
            
        })
        
        task.resume()
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.completion = completionBlock
        
    }
    

    
}

