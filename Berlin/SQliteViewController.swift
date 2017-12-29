//
//  SQliteViewController.swift
//  Berlin
//
//  Created by Bibek on 12/14/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import SQLite


//model data
struct SubCategory : Decodable {
    
    let Menu_Type : String
    let Item_Desc : String
    let Item_Price : String
    let Item_Name : String
    let Image : String
}

class SQliteViewController: UIViewController {
    
    var SubCategoryJsonData = [SubCategory]()
    let jsonUrl = "http://appybite.com/Vedis/Vedis/api.php"
    
    //define database connection
    var database1: Connection!
    
    //defining table name
    let usersTable = Table("menu")
    
    //defining table name
    let cartTable = Table("cart")
    
    //define column name
    
    let price = Expression<String>("price")
    let quantity = Expression<String>("quantity")
    let name = Expression<String>("name")
    
    //define column name
    let id = Expression<Int>("id")
    let menu_type = Expression<String>("menu_type")
    let item_desc = Expression<String>("item_desc")
    let item_price = Expression<String>("item_price")
    let item_title = Expression<String>("item_title")
    let image = Expression<String>("image")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //start animation
        
        SetAnimation.forDataFetching.startAnimation()
        
        //call json method
        JsonDownload()
        
        
        do {
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("menu").appendingPathExtension("sqlite3")
            
            let database = try Connection(fileUrl.path)
            print(database)
            
            self.database1 = database
        } catch  {
            print(error)
        }
        
        //call creatTable method
        createTable()
        createCartTable()
        
        //get the row count
        
        do{
            try  print("sizedata",self.database1.scalar(usersTable.count))
            
        }catch{
            print(error)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCreateTable(_ sender: UIButton) {
        
        createTable()
    }
    
    @IBAction func btnInsertTable(_ sender: UIButton) {
        // insertTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnListUser(_ sender: UIButton) {
        //        ListUser1(value: "Vorspeisen")
    }
    
    //create table
    
    func createTable() {
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.menu_type)
            table.column(self.item_title)
            table.column(self.item_desc)
            table.column(self.item_price)
            table.column(self.image)
        }
        
        do {
            try self.database1.run(createTable)
            print("Created Table")
        } catch  {
            print(error)
        }
    }
    
    
    //json parsing
    
    func JsonDownload() {
        
        let url = URL(string: jsonUrl)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            do {
                
                self.SubCategoryJsonData = try JSONDecoder().decode([SubCategory].self, from: data!)
                
                DispatchQueue.main.async {
                    for eachUser in self.SubCategoryJsonData {
                        
                        let imageUrl: String = "http://appybite.com/Vedis/Vedis/Image/"+eachUser.Image
                        
                        do{
                            // 1. wrap everything in a transaction
                            try self.database1.transaction {
                                
                                // scope the update statement (any row in the word column that equals "hello")
                                let filteredTable = self.usersTable.filter(self.item_title == eachUser.Item_Name)
                                
                                // 2. try to update
                                if try self.database1.run(filteredTable.update(self.menu_type <- eachUser.Menu_Type, self.item_title <- eachUser.Item_Name, self.item_desc <- eachUser.Item_Desc, self.item_price <- eachUser.Item_Price, self.image <- imageUrl)) > 0 { // 3. check the rowcount
                                    
                                    print("updated")
                                    
                                } else { // update returned 0 because there was no match
                                    
                                    // 4. insert the word
                                    let insertUser = self.usersTable.insert(self.menu_type <- eachUser.Menu_Type, self.item_title <- eachUser.Item_Name, self.item_desc <- eachUser.Item_Desc, self.item_price <- eachUser.Item_Price, self.image <- imageUrl)
                                    
                                    do {
                                        try self.database1.run(insertUser)
                                        print("Inserted User")
                                    } catch  {
                                        print(error)
                                    }
                                }
                            } // 5. if successful, transaction is commited
                            
                        }catch {
                            print(error)
                        }
                        
                        // print("Username",eachUser.Username)
                        
                        
                        
                    }
                    
                    SetAnimation.forDataFetching.stopAnimation()
                    let vc  = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                    self.present(vc, animated: true, completion: nil)
                }
                
            }
            catch {
                
                print("Error")
                
            }
            
            }.resume()
        
    }
    
    //create table
    
    func createCartTable() {
        let createTable = self.cartTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.price)
            table.column(self.name)
            table.column(self.quantity)
            
        }
        
        do {
            try self.database1.run(createTable)
            print("Created Table")
        } catch  {
            print(error)
        }
    }
    
    
}
