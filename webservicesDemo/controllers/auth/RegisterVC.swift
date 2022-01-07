//
//  RegisterVC.swift
//  webservicesDemo
//
//  Created by elfakharany on 1/18/19.
//  Copyright © 2019 Mohamed Elfakharany. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var passwordConfermationTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        guard let name = nameTF.text?.trimmed , !name.isEmpty else {return}
        
        guard let email = emailTF.text?.trimmed , !email.isEmpty else {return}
        
        guard let password = passwordTF.text ,!password.isEmpty else {return}
        
        guard let passwordConfirmation = passwordConfermationTF.text ,!passwordConfirmation.isEmpty else {return}
        
        guard  password == passwordConfirmation else {return}
        
        API.register(name: name, email: email, password: password, completion: ({ (error:Error?, success : Bool) in
            if success {
                print("register successed || welcome to our small app")
            }
        }))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
/*
 
 API.login(email: email, password: password) { (error: Error?, success: Bool) in
 if success {
 print("welcome Honey")
 }
 else{
 print("sorry Honey")
 } 
 
 */
