//
//  Photo.swift
//  webservicesDemo
//
//  Created by elfakharany on 2/10/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import Foundation
import SwiftyJSON
class Photo: NSObject {

            /*
         "photo": {
                 "user_id": 216,
                 "updated_at": "2019-02-11 09:14:30",
                 "created_at": "2019-02-11 09:14:30",
                 "id": 285,
                 "photo": "uploads/photos/154987647028173.jpeg"
         }  */
    
    var id : Int
    var url : String
    init?(dict:[String : JSON]){
        guard let id = dict["id"]?.toInt , let photo = dict ["photo"]?.toImagePath , !photo.isEmpty else { return nil }
        self.id = id
        self.url = photo
    }
}
