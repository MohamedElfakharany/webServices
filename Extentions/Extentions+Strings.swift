//
//  Extentions+Strings.swift
//  webservicesDemo
//
//  Created by elfakharany on 1/21/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import Foundation
extension String {
    var trimmed: String {
        
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
}
