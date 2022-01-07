//
//  Bool+Extention.swift
//  webservicesDemo
//
//  Created by elfakharany on 2/6/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import Foundation

extension Bool {
    
    var toInt : Int {
        
        return  NSNumber(booleanLiteral: self ).intValue
    }
    
}
