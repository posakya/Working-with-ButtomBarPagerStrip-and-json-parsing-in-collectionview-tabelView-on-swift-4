//
//  CartDetailViewController.swift
//  Berlin
//
//  Created by Bibek on 12/18/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import SQLite

class CartDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PayPalPaymentDelegate {
    
    //the defaultvalues to store user data
    var defaultValues = UserDefaults.standard
    
    var button: UIButton!
    
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration() // default
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //define database connection
    var database1: Connection!
    
    var timer = Timer()
    var isTimerRunning = false
    
    var data: Int!
    var value: String!
    
    let name = Expression<String>("name")
    let quantity = Expression<String>("quantity")
    let price = Expression<String>("price")
    
    var name1 : [String]?
    var price1 : [String]?
    var quantity1 : [String]?
    
    
    //defining table name
    let usersTable = Table("cart")
    
    
    @IBOutlet weak var btnCount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        payMentIntegration()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        btnCount.layer.cornerRadius = 0.5 * btnCount.bounds.size.width
        
        do {
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("menu").appendingPathExtension("sqlite3")
            
            let database = try Connection(fileUrl.path)
            print(database)
            
            self.database1 = database
        } catch  {
            print(error)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        
        
    }
    
    @objc func updateTimer() {
        
        do{
            let price =  try self.database1.prepare("SELECT  sum(price) as price FROM cart")
            
            for row1 in price {
                
                // timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(CartDetailViewController.updateTimer)), userInfo: nil, repeats: true)
                
                
                
                let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
                customView.backgroundColor = UIColor(red:0.47, green:0.01, blue:0.02, alpha:1.0)
                
                
                button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
                
                /*
                 menuButton.target=revealViewController()
                 menuButton.action=#selector(SWRevealViewController.revealToggle(_:))
                 */
                
                button.setTitle("Pay Amount : € \(row1[0] ?? 0)", for: .normal)
                self.defaultValues.set(row1[0], forKey: "price")
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                customView.addSubview(button)
                btnCount.setTitle(String(try self.database1.scalar(usersTable.count)), for: .normal)
                
                tableView.tableFooterView = customView
                
            }
            
            
        }catch {
            print(error)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        do{
            
            data = try self.database1.scalar(usersTable.count)
            
        }
        catch{
            print(error)
        }
        
        
        return data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        
        do {
            
            
            let users =  try self.database1.prepare("SELECT  price, name, quantity FROM cart group by name")
            
            
            name1 = [String]()
            price1 = [String]()
            quantity1 = [String]()
            
            
            for row1 in users {
                
                price1?.append(row1[0] as! String)
                name1?.append(row1[1] as! String)
                quantity1?.append(row1[2] as! String)
                
                print("name :\(String(describing: row1[1])), price: \(String(describing: row1[0])), quantity: \(String(describing: row1[2]))")
            }
            
        } catch  {
            print(error)
        }
        
        
        cell.labelName.text! = (self.name1?[indexPath.row])!
        cell.labelQuantity.text! = (self.quantity1?[indexPath.row])!
        cell.labelPrice.text! = (self.price1?[indexPath.row])!
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell1:CartTableViewCell = tableView.cellForRow(at: indexPath) as! CartTableViewCell
        
        let alert = UIAlertController(title: "Update or Delete", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in tf.text = cell1.labelName.text!}
        alert.addTextField { (tf) in tf.placeholder = "1"}
        
        let actionDelete = UIAlertAction(title: "Delete", style: .default) {
            (_) in
            let name = cell1.labelName.text!
            
            
            let GutscheinName = self.usersTable.filter(self.name == name)
            
            let deleteTable = GutscheinName.delete()
            do {
                try self.database1.run(deleteTable)
                print("Deleted Data")
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            } catch  {
                print(error)
            }
        }
        
        let actionUpdate = UIAlertAction(title: "Update", style: .default) {
            (_) in
            let name = cell1.labelName.text!
            guard let quantity2 = alert.textFields?.last?.text
                else{
                    return
            }
            
            let quantity1 = self.usersTable.filter(self.name == name)
            
            var priceValue: Float
            var quantityValue: Float
            var subTotal: Float
            var TotalPrice: Float
            
            priceValue = Float(cell1.labelPrice.text!)!
            quantityValue = Float(cell1.labelQuantity.text!)!
            subTotal = priceValue / quantityValue
            TotalPrice = subTotal * Float(quantity2)!
            
            let updateQuantity = quantity1.update(self.quantity <- quantity2, self.price <- String(TotalPrice))
            
            do {
                try self.database1.run(updateQuantity)
                print("Updated Quantity")
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            } catch  {
                print(error)
            }
        }
        
        
        
        alert.addAction(actionUpdate)
        alert.addAction(actionDelete)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //paypal integration
    
    func payMentIntegration() {
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = true
        payPalConfig.merchantName = "An indian restaurant and coctailbar, Inc."
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        
        // See PayPalConfiguration.h for details.
        
        payPalConfig.payPalShippingAddressOption = .both;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PayPalMobile.preconnect(withEnvironment: environment)
    }
    
    
    @objc func buttonAction(_ sender: UIButton!) {
        
        sender.flash1()
        
        //let total = subtotal.adding(shipping).adding(tax)
        let totalPrice = self.defaultValues.string(forKey: "price")
        
        
        let total = NSDecimalNumber(string: totalPrice)
        
        let payment = PayPalPayment(amount: total, currencyCode: "EUR", shortDescription: "Test Payment", intent: .sale)
        
        payment.items = nil
        payment.paymentDetails = nil
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
            print("Payment not processalbe: \(payment)")
        }
    }
    
    
    // PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        
        
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            
            self.deleteCartdata()
            
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
            
        })
    }
    
    func deleteCartdata() {
        let delete = self.usersTable.delete()
        
        do {
            try self.database1.run(delete)
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "homeNav") as! SWRevealViewController
            self.present(vc, animated: true, completion: nil)
            print("Deleted Data")
        } catch  {
            print(error)
        }
    }
 
}

extension UIButton {
    
    
    func flash1() {
        
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
