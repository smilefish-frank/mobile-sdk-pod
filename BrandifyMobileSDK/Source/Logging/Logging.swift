//
//  Logging.swift
//  SFLibrary
//
//  Created by Justin-Nicholas Toyama on 7/15/15.
//  Copyright (c) 2015 Rodolfo Mancilla. All rights reserved.
//

import Foundation

public func DLog(message: String, function: String = __FUNCTION__) {
    #if DEBUG
        print("\(function): \(message)")
    #endif
}