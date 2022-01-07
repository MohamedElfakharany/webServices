//
//  AppDelegate.swift
//  webservicesDemo
//
//  Created by elfakharany on 1/17/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
//
//        if let api_token = Helper.getApiToken() {
//            print("api_token is : \(api_token)")
//
//            let tab = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "main")
//            window?.rootViewController = tab
//
//
//        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "main")
        
        return true
    }


}

