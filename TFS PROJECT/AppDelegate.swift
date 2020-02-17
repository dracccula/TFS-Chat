//
//  AppDelegate.swift
//  TFS PROJECT
//
//  Created by Vladislav Kireev on 17.02.2020.
//  Copyright © 2020 VK. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
var window: UIWindow?
    
    //MARK: Debug configuration check
    #if DEBUG
        let debug = true
    #else
        let debug = false
    #endif
    
    //MARK: State's defaults
    var pastState = "No status"
    var currentState  = String()
    
    //MARK: Checking application state function
    func stateCheck (function : String) {
        switch UIApplication.shared.applicationState {
        case .active where currentState != "Active":
            currentState = "Active"
            print("Application moved from \(pastState) to \(currentState): \(function)")
            pastState = currentState
        case .background where currentState != "Background":
            currentState = "Background"
            print("Application moved from \(pastState) to \(currentState): \(function)")
            pastState = currentState
        case .inactive where currentState != "Inactive":
            currentState = "Inactive"
            print("Application moved from \(pastState) to \(currentState): \(function)")
            pastState = currentState
        default:
            print("State hasn't change: \(function)")
        }
    }


    //MARK: Application lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        debug ? stateCheck(function: #function):()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        debug ? stateCheck(function: #function):()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        debug ? stateCheck(function: #function):()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        debug ? stateCheck(function: #function):()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        debug ? stateCheck(function: #function):()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        debug ? stateCheck(function: #function):()
    }

}

