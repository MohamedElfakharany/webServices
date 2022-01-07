//
//  Config.swift
//  webservicesDemo
//
//  Created by elfakharany on 1/21/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import Foundation

struct URLs{

    static let main = "http://elzohrytech.com/alamofire_demo/api/v1/"
    static let file_root = "http://elzohrytech.com/alamofire_demo/"
    
    
    // MARK:- AUTH
    /// POST {email , password}
    static let login = main + "login"
    
    /// POST {name , email  , password , password_Confirmation }
    static let register = main + "register"
    
    // MARK:- Tasks
    /// GET {api_token , page , per_page }
    static let tasks = main + "tasks"
    
    /// POST {api_token , new_task}
    static let new_task = main + "task/create"
    
    /// POST {api_token , task_id}
    static let delete_task = main + "task/delete"
    
    /// POST {api_token , task_id , task(optional), completed(optional)}
    static let edit_task = main + "task/edit"
    
    // MARK:- Photos
    
    /// GET {api_token}
    static let photos = main + "photos"
    
    /// Post {api_token} andd file {photo}
    static let create_Photo = main + "photo/create"
}
