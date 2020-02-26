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

}

