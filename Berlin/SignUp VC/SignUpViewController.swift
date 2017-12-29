//
//  SignUpViewController.swift
//  Berlin
//
//  Created by Bibek on 12/12/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import Alamofire

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    var fileUrl : URL!
    var chosenImage : UIImage!
    
    //the defaultvalues to store user data
    let defaultValues = UserDefaults.standard
    
    let URL_USER_Register = "http://appybite.com/Vedis/Vedis/register.php"
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBAction func btnAlreadyExist(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        userImage.layer.cornerRadius = userImage.frame.size.width / 2;
        //        userImage.clipsToBounds = true
        //        userImage.layer.borderColor = UIColor.white.cgColor
        //        userImage.layer.borderWidth = 1.5
        
        
        imagePicker.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.click))
        userImage.addGestureRecognizer(tap)
        userImage.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let stringOne = self.defaultValues.string(forKey: "email")
        let stringtwo = self.defaultValues.string(forKey: "password")
        
        print("Email ",stringtwo as Any)
        
        if (stringOne != nil && stringtwo != nil) {
            
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "homeNav") as! SWRevealViewController
            self.present(vc, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func click()
    {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        userImage.contentMode = .scaleAspectFit
        userImage.image = chosenImage
        
        if #available(iOS 11.0, *) {
            fileUrl = info[UIImagePickerControllerImageURL] as? URL
        } else {
            // Fallback on earlier versions
        }
        print("Filename ",fileUrl?.lastPathComponent as Any)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnRegister(_ sender: UIButton) {
        
        let imageData = UIImageJPEGRepresentation(userImage.image!, 0.2)
        
        if txtUsername.text == ""{
            AlertDisplayWith(Constant.AppName, body: "Email required", vc: self)
        }
            
        else if txtEmail.text == ""{
            AlertDisplayWith(Constant.AppName, body: "Email required", vc: self)
        }
            
        else if txtPhone.text == ""{
            AlertDisplayWith(Constant.AppName, body: "Phone Number required", vc: self)
        }
            
        else if txtPassword.text == ""{
            AlertDisplayWith(Constant.AppName, body: "Password required", vc: self)
        }
            
        else if txtConfirmPass.text == ""{
            AlertDisplayWith(Constant.AppName, body: "Confirm Password required", vc: self)
        }
            
        else if imageData == nil{
            AlertDisplayWith(Constant.AppName, body: "Insert Image", vc: self)
        }
            
        else if(txtPassword.text != txtConfirmPass.text) {
            AlertDisplayWith(Constant.AppName, body: "Password does not match", vc: self)
        }
            
        else {
            
            SetAnimation.forDataFetching.startAnimation()
            
            let parameters: Parameters=[
                "Username":txtUsername.text!,
                "Email":txtEmail.text!,
                "Password":txtPassword.text!,
                "Confirm_pass":txtConfirmPass.text!,
                "Contact":txtPhone.text!
            ]
            
            let FileName = fileUrl.absoluteString
            print("ImageName :",FileName)
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                
                multipartFormData.append(imageData!, withName: "Image", fileName: FileName, mimeType: "image/jpeg")
                
                
                for (key, value) in parameters {
                    multipartFormData.append(((value as AnyObject).data(using: UInt(UInt64.init())))!, withName: key)
                }}, to: URL_USER_Register, method: .post,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.response { [weak self] response in
                                guard self != nil else {
                                    return
                                }
                                SetAnimation.forDataFetching.stopAnimation()
                                self?.defaultValues.set(self?.txtEmail.text!, forKey: "email")
                                self?.defaultValues.set(self?.txtPassword.text!, forKey: "password")
                                
                                let vc  = self?.storyboard?.instantiateViewController(withIdentifier: "homeNav") as! SWRevealViewController
                                
                                self?.present(vc, animated: true, completion: nil)
                                
                                debugPrint(response)
                            }
                        case .failure(let encodingError):
                            print("error:\(encodingError)")
                        }
            })
            
        }
    }
    
    public func AlertDisplayWith(_ title:String?,body:String?,vc:UIViewController){
        let alert = UIAlertController(title: title, message: body, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
}
