//
//  ViewController.swift
//  webservicesDemo
//
//  Created by elfakharany on 1/17/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        
        guard let email = emailTF.text , !email.isEmpty else {return}
        
        guard let password = passwordTF.text , !password.isEmpty else {return}
        
        API.login(email: email, password: password) { (error: Error?, success: Bool) in
            if success {
                print("welcome Honey")
            }
            else{
                print("sorry Honey")
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
         
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

}

