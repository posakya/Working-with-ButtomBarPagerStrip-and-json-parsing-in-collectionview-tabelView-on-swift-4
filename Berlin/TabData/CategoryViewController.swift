//
//  CategoryViewController.swift
//  Berlin
//
//  Created by Bibek on 12/4/17.
//  Copyright © 2017 Bibek. All rights reserved.

/*
 UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, IndicatorInfoProvider {
 
 */
//

import UIKit
import XLPagerTabStrip

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    
    //the defaultvalues to store user data
    var defaultValues = UserDefaults.standard
    
    init(itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    var MenuDescription:Array = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = UIColor.lightGray
        
        ManuNameArray = ["Vorspeisen","Suppen","Beilagen","Salate","Vegetarisch","Hühnerfleisch","Lammfleisch","Ente","Fisch/Scampi","Reisgerichte","TandooriGrill","Desserts","Cocktails"]
        
        iconArray = [UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!,UIImage(named:"chicken_vindaloo")!]
        
        MenuDescription = ["Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s","Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.labelTitle.text! = ManuNameArray[indexPath.row]
        cell.uiImage.image = iconArray[indexPath.row]
        cell.labelDescription.text! = MenuDescription[indexPath.row]
        cell.labelDescription.numberOfLines=5
        cell.backgroundColor = UIColor.clear
        //  cell.contentView.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.5)
        // add border and color
        cell.backgroundColor = UIColor.white
        //        cell.layer.borderColor = UIColor.clear.cgColor
        //        cell.layer.borderWidth = 2
        // cell.layer.cornerRadius = 8
        // cell.clipsToBounds = true
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell1:TableViewCell = tableView.cellForRow(at: indexPath) as! TableViewCell
        
        self.defaultValues.set(cell1.labelTitle.text!, forKey: "title")
        
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainstoryboard.instantiateViewController(withIdentifier: "SubCategoryViewController") as! SubCategoryViewController
        self.present(vc, animated: true, completion: nil)
        
        print("Selected :",cell1.labelTitle.text!)
    }
    
    
    
}
