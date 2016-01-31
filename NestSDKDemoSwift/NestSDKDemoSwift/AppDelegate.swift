//
//  AppDelegate.swift
//  NestSDKDemoSwift
//
//  Created by Petro Akzhygitov on 31/01/16.
//  Copyright © 2016 Petro Akzhygitov. All rights reserved.
//

import UIKit
import NestSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {
        NestSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }
}

