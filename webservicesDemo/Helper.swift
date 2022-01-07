//
//  Helper.swift
//  webservicesDemo
//
//  Created by elfakharany on 2/3/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    class func RestartApp(){
        guard let window = UIApplication.shared.keyWindow else {return}
        let sb = UIStoryboard ( name : "Main" , bundle : nil)
        var vc : UIViewController
        if getApiToken() == nil {
            vc = sb.instantiateInitialViewController()!
        }else {
            vc = sb.instantiateViewController(withIdentifier: "main")
        }
        window.rootViewController = vc
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCurlDown, animations: nil, completion: nil)
        
    }
    
    class func saveApiToken ( token : String ){
        let def = UserDefaults.standard
        def.setValue(token, forKey: "api_token")
        def.synchronize()
        
        RestartApp()
    }
    
    class func getApiToken () -> String?{
        let def = UserDefaults.standard
        return (def.object(forKey: "api_token")  as? String?)!
        
    }
}
