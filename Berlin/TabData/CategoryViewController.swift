//
//  CategoryViewController.swift
//  Berlin
//
//  Created by Bibek on 12/4/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {
   
    var itemInfo: IndicatorInfo = "View"
    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return ManuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.labelTitle.text! = ManuNameArray[indexPath.row]
        cell.uiImage.image = iconArray[indexPath.row]
        cell.labelDescription.text! = MenuDescription[indexPath.row]
       // cell.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.5)
 return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:TableViewCell = tableView.cellForRow(at: indexPath) as! TableViewCell
        print(cell.labelTitle.text!)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        ManuNameArray = ["Home","History","Find Location","Offers","Support","Notification"]
        print("Menu",MenuDescription)
        iconArray = [UIImage(named:"gutschein")!,UIImage(named:"reservation")!,UIImage(named:"gutschein")!,UIImage(named:"reservation")!,UIImage(named:"reservation")!,UIImage(named:"gutschein")!]
        
        MenuDescription = ["Home","History","Find Location","Offers","Support","Notification"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
