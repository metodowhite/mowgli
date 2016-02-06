//
//  AppConfiguration.swift
//  Mowgli
//
//  Created by Lulu on 10/07/15.
//  Copyright (c) 2015 metodowhite. All rights reserved.
//

import Foundation

import Parse
import Bolts
import ParseFacebookUtilsV4


public class AppConfiguration {
    
    static let shared= AppConfiguration()
    
    init() {}
    
    public func runBaasSetup(launchOptions launchOptions: [NSObject: AnyObject]?) {
        _ = ParseConfiguration(launchOptions: launchOptions)
        
    }
}

private struct ParseConfiguration {
    
    init(launchOptions: [NSObject: AnyObject]?) {
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("GYYqUwHxRuUPeWLmqPDXZOsI1IyhfLDFWiLaAlho",
            clientKey: "6hrJmpaBGhwjmbWRyPCtZ6D9fo3qgbiRpvzwNMHv")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
    }
}