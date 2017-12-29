//
//  SignInViewController.swift
//  Berlin
//
//  Created by Bibek on 12/11/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController {
    
    let URL_USER_LOGIN = "http://appybite.com/Vedis/Vedis/login.php"
    
    //the defaultvalues to store user data
    var defaultValues = UserDefaults.standard
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let stringOne = self.defaultValues.string(forKey: "email")
        let stringtwo = self.defaultValues.string(forKey: "password")
        
        print("Email ",stringtwo as Any)
        
        if (stringOne != nil && stringtwo != nil) {
            
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "homeNav") as! SWRevealViewController
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBAction func btnLogin(_ sender: UIButton) {
        print("Tapped")
        
        sender.flash2()
        
        if txtEmail.text == ""{
            AlertDisplayWith(Constant.AppName, body: "Email required", vc: self)
        }
        else if txtPassword.text == ""{
            AlertDisplayWith(Constant.AppName, body: "Password required", vc: self)
        }
            
        else{
            SetAnimation.forDataFetching.startAnimation()
            //getting the username and password
            let parameters: Parameters=[
                "Email":txtEmail.text!,
                "Password":txtPassword.text!
            ]
            
            
            Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
                {
                    response in
                    //printing response
                    print(response)
                    
                    //getting the json value from the server
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                        
                        
                        let value: String = jsonData.value(forKey: "success") as! String
                        
                        //
                        if(value == "1"){
                            SetAnimation.forDataFetching.stopAnimation()
                            self.defaultValues.set(self.txtEmail.text!, forKey: "email")
                            self.defaultValues.set(self.txtPassword.text!, forKey: "password")
                            
                            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "homeNav") as! SWRevealViewController
                            self.present(vc, animated: true, completion: nil)
                            
                            self.txtPassword.insertText("")
                            self.txtEmail.insertText("")
                            
                            
                        }
                            
                        else{
                            SetAnimation.forDataFetching.stopAnimation()
                            let alertController = UIAlertController(title: Constant.AppName, message: "Invalid username or password", preferredStyle: .alert)
                            
                            
                            let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
                                UIAlertAction in
                                SetAnimation.forDataFetching.stopAnimation()
                                NSLog("Cancel Pressed")
                            }
                            
                            // Add the actions
                            // alertController.addAction(okAction)
                            alertController.addAction(cancelAction)
                            
                            // Present the controller
                            self.present(alertController, animated: true, completion: nil)
                            //error message in case of invalid credential
                            print("Invalid username or password")
                        }
                        
                    }
            }
        }
        
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func AlertDisplayWith(_ title:String?,body:String?,vc:UIViewController){
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    
}

extension UIButton {
    
    
    func flash2() {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        
        layer.add(flash, forKey: nil)
    }
    
}
