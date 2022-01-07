//
//  API + Photos.swift
//  webservicesDemo
//
//  Created by elfakharany on 2/10/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension API {
    
    class func photos(page : Int = 1 , completion : @escaping (_ error :Error?, _ photos: [ Photo]?, _ last_page: Int)->Void ){
        
        guard let api_token = Helper.getApiToken()?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)else {
            completion (nil , nil , page )
            return
        }
        let url = URLs.photos+"?api_token=\(api_token)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { response in
            switch response.result
            {
            case .failure (let error):
                print(error)
                completion(nil,nil,page)
            case .success(let value):
                let json = JSON(value)
                print (json)
                guard let data = json["data"].array else {
                    completion(nil,nil,page)
                    return
                }
                var photos = [Photo]()
                data.forEach({
                    if let dict = $0.dictionary ,let photo = Photo ( dict : dict){
                        photos.append(photo)
                    }
                    }
                )
                let last_page = json["last_page"].toInt ?? page
                completion (nil, photos, last_page)
            }
            
            
        }
        
    }
    
    class func create_Photo (photo: UIImage ,  completion : @escaping (_ error :Error? , _ success :Bool)->Void){
        
        guard let api_token = Helper.getApiToken()?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)else {
            completion (nil , false)
            return
        }
        let url = URLs.create_Photo+"?api_token=\(api_token)"
        
        Alamofire.upload(multipartFormData: { (form :MultipartFormData) in
            let fucken_image = UIImage()
            if let data = fucken_image.jpegData(compressionQuality: 0.5){
                form.append(data, withName: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: nil) {
            (result: SessionManager.MultipartFormDataEncodingResult) in
            
            switch result {
            case .failure (let error) :
                print(error)
                completion (error , false)
            case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                upload.uploadProgress(closure: {(Progress:Progress)in
                    print(Progress)
                })
                    .responseJSON(completionHandler: { (response: DataResponse<Any>) in
                        switch response.result {
                        case .failure(let error ):
                            print(error)
                            completion(error , false)
                        case .success(let value):
                            let json = JSON(value)
                            print(value)
                            if let status = json["status"].toInt , status == 1 {
                                print("upload succeed")
                                completion(nil,true)
                            }else {
                                print("upload failed ")
                                completion(nil,false)
                            }
                        }
                    }
                )
            }
            
        }
        
    }
}
