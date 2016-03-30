//Brandify iOS SDK
//BFBaseModel.swift

import Foundation


public class BFModelStatus : NSObject
{
    public var code : Int = 999
    public var statusDescription : String? = "An error has occured."
    public var stackTrace : String? = String()

    override init()
    {
        
        super.init()
        
    }
    
}


public class BFSecurityContext : NSObject
{
    
    public var authToken : String? //GUID
    public var apiKey:String?
    
    func readFromJSONDictionary(dict:NSDictionary!)
    {
        
        self.authToken = dict.objectForKey("AuthToken") as? String

        // don't read other keys because client should specify those
        
    }
    
    func getJsonDictionary() -> NSDictionary
    {
        
        let securityContextDict = NSMutableDictionary()
        
        if self.authToken != nil && self.authToken != "00000000-0000-0000-0000-000000000000" && self.authToken != ""
        {
        
            if self.authToken != nil
            {
                
                securityContextDict["AuthToken"] = authToken
                
            }
            
        }
        else
        if self.apiKey != nil && self.apiKey != ""
        {

                securityContextDict["ApiKey"] = apiKey

        }
        else
        {
            
            DLog("BFBaseModel.getJSONDictionary() - ERROR: Could not create security context!")
            
        }
        
        return securityContextDict
        
    }
    
}

public class BFBaseModel : NSObject
{
    public var securityContext: BFSecurityContext!
    
    convenience init(JSONDictionary:Dictionary<String, AnyObject!>)
    {
        self.init()
        
        readFromJSONDictionary(JSONDictionary)
    }
    
    override init()
    {
        
        super.init()
       
        self.securityContext = BFSecurityContext()
        
    }

    func getJsonDictionary() -> NSDictionary
    {
        
        let baseModelDict = NSMutableDictionary()
        
        
        let scd = securityContext.getJsonDictionary()
        
        return ["Status" : baseModelDict, "SecurityContext" : scd] as NSMutableDictionary
        
    }

    func getJSONDictionaryString() -> NSString
    {
        
        let dictionary = NSDictionary()
   
        var result: NSData?
        
        do {
            
            result = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
            
        } catch {
            
            print("BFContact getJSONDictionaryString() - Could not get JSON")
            
        }
        
        var jsonString:NSString = ""
        
        if result != nil
        {
            jsonString = NSString(data:result!, encoding : NSUTF8StringEncoding)!
            
        }

        
        return jsonString
        
    }
    
    func getJSONObject() -> NSObject {
        return ""
    }
    
    func readFromJSONDictionary(dict:NSDictionary!)
    {
        
    }
}

public class BFCollectionBaseModel:BFBaseModel
{
    
    public override func getJSONDictionaryString() -> NSString
    {
     
        return ""
        
    }
    
}

class BFAuthorizationResponse: BFBaseModel
{
    
}