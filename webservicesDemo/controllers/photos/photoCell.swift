//
//  photoCell.swift
//  webservicesDemo
//
//  Created by elfakharany on 2/6/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class photoCell: UICollectionViewCell {

    @IBOutlet weak var iv: UIImageView!
    
    var photo:Photo? {
        didSet {
            guard let photo = photo else { return }
            iv.image = #imageLiteral(resourceName: "placeholder.jpg")
            
            // download images using Alamofire
            
           /* Alamofire.request(photo.url).response {
                response in
                if let data = response.data , let image = UIImage(data: data) {
                    self.iv.image = image
                }
            }*/
            
            // download images using Kingfisher
            self.iv.kf.indicatorType = .activity
            if let url = URL(string:  photo.url){
                self.iv.kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.flipFromTop(0.5))], progressBlock: nil, completionHandler: nil)
            }
            
        }
    }

}
