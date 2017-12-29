//
//  MenuViewController.swift
//  Berlin
//
//  Created by Bibek on 12/1/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import SDWebImage

struct UserData : Decodable {
    let Image : String
    let Username : String
}

class MenuViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    //the defaultvalues to store user data
    var defaultValues = UserDefaults.standard
    
    
    var UserJsonData = [UserData]()
    
    
    
    
    @IBOutlet weak var userImage: UIImageView!
    
    var ManuNameArray:Array = [String]()
    
    var iconArray:Array = [UIImage]()
    
    @IBOutlet weak var labelUserName: UILabel!
    
    @IBAction func btnUpdateProPic(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        JsonDownload()
        
        ManuNameArray = ["Home","History","Find Location","Offers","Support","Notification","Log Out"]
        iconArray = [UIImage(named:"ic_home")!,UIImage(named:"history")!,UIImage(named:"placeholder")!,UIImage(named:"tag")!,UIImage(named:"support")!,UIImage(named:"notification")!,UIImage(named:"logout")!]
        
        userImage.layer.cornerRadius = userImage.frame.size.width / 2;
        userImage.clipsToBounds = true
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.borderWidth = 1.5
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("Length ",ManuNameArray.count)
        return ManuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        cell.uiText.text! = ManuNameArray[indexPath.row]
        cell.uiImage.image = iconArray[indexPath.row]
        cell.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.5)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
        
        let cell:MenuTableViewCell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        print(cell.uiText.text!)
        if(cell.isSelected){
            cell.backgroundColor = UIColor.red
        }else{
            cell.backgroundColor = UIColor.clear
        }
        if cell.uiText.text! == "Home"
        {
            print("Home Tapped")
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
            
        }
        
        
        if cell.uiText.text! == "History"
        {
            
            
            print("history Tapped")
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        //
        if cell.uiText.text! == "Notification"
        {
            print("notification Tapped")
            
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        //
        if cell.uiText.text! == "Find Location"
        {
            print("location Tapped")
            
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        //
        if cell.uiText.text! == "Offers"
        {
            print("offer Tapped")
            
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "OfferViewController") as! OfferViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        
        if cell.uiText.text! == "Support"
        {
            print("support Tapped")
            
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }
        
        if cell.uiText.text! == "Log Out"
        {
            print("Log Out Tapped")
            
            // Create the alert controller
            let alertController = UIAlertController(title: Constant.AppName, message: "Do you want to logout?", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                UserDefaults.standard.removeObject(forKey: "email")
                UserDefaults.standard.removeObject(forKey: "password")
                self.dismiss(animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        }
        
        
        
    }
    func JsonDownload() {
        
        let stringOne = self.defaultValues.string(forKey: "email")!
        
        let jsonUrl = "http://appybite.com/Vedis/Vedis/user_profile.php?Email="+stringOne
        
        let url = URL(string: jsonUrl)
        print("URL :",url as Any)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            do {
                
                self.UserJsonData = try JSONDecoder().decode([UserData].self, from: data!)
                
                DispatchQueue.main.async {
                    
                    for eachUser in self.UserJsonData {
                        
                        print("Username",eachUser.Username)
                        
                        self.labelUserName.text!=eachUser.Username
                        let imageUrl: String = "http://appybite.com/Vedis/Vedis/Image/"+eachUser.Image
                        
                        self.userImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
                        
                    }
                    
                }
            }
            catch {
                
                print("Error")
                
            }
            
            }.resume()
        
    }
    
}
