//
//  TestViewController.swift
//  Berlin
//
//  Created by Bibek on 12/9/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit

import XLPagerTabStrip
import SDWebImage

struct HomeData : Decodable {
    let Image : String
    let Description : String
    let Title : String
}

class TestViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, IndicatorInfoProvider {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var HomeJsonData = [HomeData]()
    let jsonUrl = "http://appybite.com/Vedis/Vedis/home_api.php"
    
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
    
    
    
    
//    var ManuNameArray:Array = [String]()
//    var iconArray:Array = [UIImage]()
//    var MenuDescription:Array = [String]()
    let numberOfColumns: CGFloat = 2
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        JsonDownload()
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout; layout?.minimumLineSpacing = 8
        
        
//        ManuNameArray = ["Home","History","Find Location","Offers","Support","Notification"]
//        print("Menu",MenuDescription)
//        iconArray = [UIImage(named:"gutschein")!,UIImage(named:"reservation")!,UIImage(named:"gutschein")!,UIImage(named:"reservation")!,UIImage(named:"reservation")!,UIImage(named:"gutschein")!]
//
//        MenuDescription = ["Home","History","Find Location","Offers","Support","Notification"]
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return HomeJsonData.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.labelTitle.text! = HomeJsonData[indexPath.row].Title
        cell.labelDescription.text! = HomeJsonData[indexPath.row].Description
        let imageUrl: String = "http://appybite.com/Vedis/Vedis/Image/"+HomeJsonData[indexPath.row].Image
      
      //  print("ImageData :",imageUrl)
        
        cell.uiImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        
    
        
     //   cell.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.5)
        return cell
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalWidth = UIScreen.main.bounds.width
        let cellWidth = totalWidth / 2 - 15.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell1:CollectionViewCell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        print("Selected :",cell1.labelTitle.text!)
    }
    
    
    
    func JsonDownload() {
        
        let url = URL(string: jsonUrl)
        
      //  print("URL :", url!)
        
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            do {
                
                self.HomeJsonData = try JSONDecoder().decode([HomeData].self, from: data!)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
//                for eachHomeJsonData in self.HomeJsonData {
//                    
//                 //   print("Image", eachHomeJsonData.Image)
//                    
//                }
                
            }
            catch {
                
                print("Error")
                
            }
            
            }.resume()
        
    }
    
}
