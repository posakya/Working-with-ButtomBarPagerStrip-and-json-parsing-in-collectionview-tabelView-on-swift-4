//
//  GutscheinViewController.swift
//  Berlin
//
//  Created by Bibek on 12/17/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import SQLite

//model data
struct GutscheinData : Decodable {
    
    let Price : String
    let Discount : String
    let Image : String
}



class GutscheinViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    
    @IBAction func btnCart(_ sender: UIButton) {
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "CartDetailViewController") as! CartDetailViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    var timer = Timer()
    var cell: GutscheinCollectionViewCell?
    
    @IBOutlet weak var btnCount: UIButton!
    //define database connection
    var database1: Connection!
    
    //defining table name
    let usersTable = Table("cart")
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //define column name
    let id = Expression<Int>("id")
    let price = Expression<String>("price")
    let quantity = Expression<String>("quantity")
    let name = Expression<String>("name")
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var GutscheinJsonData = [GutscheinData]()
    let jsonUrl = "http://appybite.com/Vedis/Vedis/gutchein_api.php"
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        SetAnimation.forDataFetching.startAnimation()
        
        
        btnCount.layer.cornerRadius = 0.5 * btnCount.bounds.size.width
        
        JsonDownload()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        do {
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let fileUrl = documentDirectory.appendingPathComponent("menu").appendingPathExtension("sqlite3")
            
            let database = try Connection(fileUrl.path)
            print(database)
            
            self.database1 = database
        } catch  {
            print(error)
        }
    }
    
    
    @objc func updateTimer() {
        
        do{
            
            btnCount.setTitle(String(try self.database1.scalar(usersTable.count)), for: .normal)
            
        }catch {
            print(error)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GutscheinJsonData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GutscheinCollectionViewCell", for: indexPath) as? GutscheinCollectionViewCell
        
        cell?.txtPrice.text! = GutscheinJsonData[indexPath.row].Price
        
        cell?.txtDiscount.text! = GutscheinJsonData[indexPath.row].Discount
        
        let imageUrl: String = "http://appybite.com/Vedis/Vedis/Image/"+GutscheinJsonData[indexPath.row].Image
        
        
        cell?.uiImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        
        
        
        cell?.btnAddtoCart.addTarget(self, action: #selector(addToCart(_:)), for: .touchUpInside)
        
        
        
        
        
        //   cell.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.5)
        
        return cell!
    }
    
    
    @objc func addToCart(_ sender:UIButton){
        
        sender.flash()
        
        let buttonPosition:CGPoint = sender.convert(.zero, to: self.collectionView)
        let indexPath:IndexPath = self.collectionView.indexPathForItem(at: buttonPosition)!
        let cell1:GutscheinCollectionViewCell = collectionView.cellForItem(at: indexPath) as! GutscheinCollectionViewCell
        
        let name = "Gutschein €"+(cell1.txtPrice.text!);
        var discountAmount: Float!
        var price: Float!
        var subtotal: Float!
        var total: Float!
        
        discountAmount = Float(cell1.txtDiscount.text!)
        price = Float(cell1.txtPrice.text!)
        
        subtotal = discountAmount / price
        total = price - subtotal * 100
        
        let totalPrice=String(total)
        
        
        
        do{
            // 1. wrap everything in a transaction
            try self.database1.transaction {
                
                // scope the update statement (any row in the word column that equals "hello")
                let filteredTable = self.usersTable.filter(self.name == name)
                
                // 2. try to update
                if try self.database1.run(filteredTable.update(self.price <- totalPrice, self.name <- name, self.quantity <- "1")) > 0 { // 3. check the rowcount
                    
                    print("updated")
                    
                } else { // update returned 0 because there was no match
                    
                    // 4. insert the word
                    let insertUser = self.usersTable.insert(self.price <- totalPrice, self.name <- name, self.quantity <- "1")
                    
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
        
        
        
        print("Selected :",cell1.txtDiscount.text! as Any)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        if deviceIdiom == .pad {
            let totalWidth = UIScreen.main.bounds.width
            let cellWidth = totalWidth / 2 - 15.0
            return CGSize(width: cellWidth, height: 250.0)
        }else if deviceIdiom == .phone {
            
            let totalWidth = UIScreen.main.bounds.width - 15.0
            
            return CGSize(width: totalWidth, height: 250.0)
        }else {
            return CGSize(width: 400.0, height: 250.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //json parsing
    
    func JsonDownload() {
        
        let url = URL(string: jsonUrl)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            do {
                
                self.GutscheinJsonData = try JSONDecoder().decode([GutscheinData].self, from: data!)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    SetAnimation.forDataFetching.stopAnimation()
                }
            }
            catch {
                
                print("Error")
                
            }
            
            }.resume()
        
    }
    
    
    
    
    
}

extension UIButton {
    
    
    func flash() {
        
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

