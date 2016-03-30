//
//  BFCoupon.swift
//  BrandifyMobileSDK
//
//  Created by Frank Ayars on 3/4/16.
//  Copyright © 2016 Brandify. All rights reserved.
//

import Foundation

public class BFCoupon : BFBaseModel
{
    public override init() {
        super.init();
    }
    public var walletType : Int = 0
    public var requestType : Int = 0
    public var couponData : NSData?
    
    override public func readFromJSONDictionary(jsonDict:NSDictionary!)
    {
        super.readFromJSONDictionary(jsonDict)
        
        if let walletType = jsonDict["WalletType"] as? Int
        {
            self.walletType = walletType
        }
        
        if let requestType = jsonDict["RequestType"] as? Int
        {
            self.requestType = requestType
        }
        
        if let couponData = jsonDict["CouponData"] as? String
        {
            self.couponData = couponData.dataUsingEncoding(NSUTF8StringEncoding)
        }
    }
}