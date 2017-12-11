//
//  MenuViewController.swift
//  Berlin
//
//  Created by Bibek on 12/1/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var userImage: UIImageView!
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ManuNameArray = ["Home","History","Find Location","Offers","Support","Notification","Log Out"]
        iconArray = [UIImage(named:"ic_home")!,UIImage(named:"history")!,UIImage(named:"placeholder")!,UIImage(named:"tag")!,UIImage(named:"support")!,UIImage(named:"notification")!,UIImage(named:"logout")!]
        
        userImage.layer.borderColor = UIColor.red.cgColor
        userImage.layer.borderWidth = 2
        userImage.layer.cornerRadius = 50
        userImage.layer.masksToBounds = false
        userImage.clipsToBounds = true
      
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
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewcontroller = mainstoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let newFrontController = UINavigationController.init(rootViewController: newViewcontroller)
            
            revealviewcontroller.pushFrontViewController(newFrontController, animated: true)
        }


    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
