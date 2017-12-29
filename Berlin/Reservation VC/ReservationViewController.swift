//
//  ReservationViewController.swift
//  Berlin
//
//  Created by Bibek on 12/13/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import SQLite
import Alamofire
import SwiftyJSON

class ReservationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let valueOfperson = ["No. of people", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"]
    
    let URL_USER_LOGIN = "http://appybite.com/Vedis/Vedis/reservation.php"
    
    var strDate: String!
    var strTime: String!
    var strQuantity: String!
    
    @IBOutlet weak var uiPicker: UIPickerView!
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var txtTelephone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    
    
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        
        
        
        super.viewDidLoad()
        
        uiPicker.delegate = self
        uiPicker.dataSource = self
        
        btnDate.addTarget(self, action: #selector(date),for: .touchUpInside)
        btnTime.addTarget(self, action: #selector(time),for: .touchUpInside)
        
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return valueOfperson.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return valueOfperson[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        strQuantity = valueOfperson[row]
    }
    
    @objc func date(sender: UIButton!) {
        
        let myDatePicker: UIDatePicker = UIDatePicker()
        // setting properties of the datePicker
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.addSubview(myDatePicker)
        
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            //dateFormatter.dateStyle = .short
            // dateFormatter.timeStyle = .short
            
            self.strDate = dateFormatter.string(from: myDatePicker.date)
            print("date",self.strDate)
            self.btnDate.setTitle(self.strDate, for: .normal)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
        
    }
    
    
    @objc func time(sender: UIButton!) {
        
        let myDatePicker: UIDatePicker = UIDatePicker()
        // setting properties of the datePicker
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alertController.view.addSubview(myDatePicker)
        
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let dateFormatter = DateFormatter()
            
            dateFormatter.timeStyle = .short
            
            self.strTime = dateFormatter.string(from: myDatePicker.date)
            print("date",self.strDate)
            self.btnTime.setTitle(self.strDate, for: .normal)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        SetAnimation.forDataFetching.startAnimation()
        
        let parameters: Parameters=[
            "Date":strDate,
            "Time":strTime,
            "Quantity":strQuantity,
            "Username":txtUsername.text!,
            "Email":txtEmail.text!,
            "Contact":txtTelephone.text!,
            "Message":txtMessage.text!,
            "Status":"0",
            "Token":"12"
        ]
        
        
        Alamofire.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                if response.result.value != nil {
                    let swiftyJsonVar = JSON(response.result.value!)
                    
                    if let data = swiftyJsonVar["notification"]["success"].string {
                        //Now you got your value
                        if(data == "1")
                        {
                            SetAnimation.forDataFetching.stopAnimation()
                            
                        }
                        
                    }
                    
                    print(swiftyJsonVar)
                }
                
        }
    }
    
}
