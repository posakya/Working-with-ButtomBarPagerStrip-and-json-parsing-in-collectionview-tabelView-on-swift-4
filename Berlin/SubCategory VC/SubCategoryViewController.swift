//
//  SubCategoryViewController.swift
//  Berlin
//
//  Created by Bibek on 12/17/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import SQLite
import SDWebImage


class SubCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    //define database connection
    var database1: Connection!
    
    var data: Int!
    var value: String!
    
    
    var  image = [String]()
    var  itemDesc = [String]()
    var  itemName = [String]()
    var  itemPrice = [String]()
    var menuType = [String]()
    
    //defining table name
    let usersTable = Table("menu")
    
    //the defaultvalues to store user data
    var defaultValues = UserDefaults.standard
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var labelName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        value = self.defaultValues.string(forKey: "title")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        labelName.text!=value
        
        
        do {
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("menu").appendingPathExtension("sqlite3")
            
            let database = try Connection(fileUrl.path)
            print(database)
            
            self.database1 = database
        } catch  {
            print(error)
        }
        
        do{
            try  print("sizedata",self.database1.scalar(usersTable.count))
            
        }catch{
            print(error)
        }
        
        
        do {
            
            
            let users =  try self.database1.prepare("SELECT menu_type, item_title, item_desc, item_price, image FROM menu where menu_type = '"+value!+"'")
            
            
            
            
            for row1 in users {
                
                menuType.append(row1[0] as! String)
                itemName.append(row1[1] as! String)
                itemDesc.append(row1[2] as! String)
                itemPrice.append(row1[3] as! String)
                image.append(row1[4] as! String)
                
                // print("name :\(String(describing: row[0])), email: \(String(describing: row[1]))")
            }
            
        } catch  {
            print(error)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //working with back button
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        print("count",menuType.count)
        
        return menuType.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubCollectionViewCell", for: indexPath) as! SubCollectionViewCell
        
        
        cell.labelTitle.text! = (self.itemName[indexPath.row])
        
        cell.labelDescription.text! = (self.itemDesc[indexPath.row]).replacingOccurrences(of: "<[^>;&]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "&nbsp;", with: "", options: .regularExpression, range: nil)
        
        cell.labelDescription.numberOfLines=3
        
        cell.btnPrice.setTitle(("€ "+self.itemPrice[indexPath.row]), for: .normal)
        
        let imageUrl: String = (self.image[indexPath.row])
        cell.menuImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        if deviceIdiom == .pad {
            let totalWidth = UIScreen.main.bounds.width
            let cellWidth = totalWidth / 2 - 15.0
            return CGSize(width: cellWidth, height: 300.0)
        }else if deviceIdiom == .phone {
            let totalWidth = UIScreen.main.bounds.width - 15.0
            return CGSize(width: totalWidth, height: 330.0)
        }else {
            return CGSize(width: 400.0, height: 250.0)
        }
        
        
    }
    
}
