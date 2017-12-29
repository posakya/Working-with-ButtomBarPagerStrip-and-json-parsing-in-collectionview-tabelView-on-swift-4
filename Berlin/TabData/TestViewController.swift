
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
    
    let numberOfColumns: CGFloat = 2
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.collectionView.layer.cornerRadius = 10.0
        self.collectionView.layer.borderWidth = 3.0
        self.collectionView.layer.borderColor = UIColor.clear.cgColor
        self.collectionView.layer.masksToBounds = true
        //
        //        self.layer.shadowColor = UIColor.lightGray.cgColor
        //        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        //        self.layer.shadowRadius = 2.0
        //        self.layer.shadowOpacity = 1.0
        //        self.layer.masksToBounds = false
        //        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        SetAnimation.forDataFetching.startAnimation()
        
        JsonDownload()
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout; layout?.minimumLineSpacing = 8
        
        
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
        
        cell.labelTitle.text! = HomeJsonData[indexPath.row].Title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        
        //let desc = HomeJsonData[indexPath.row].Description.replacingOccurrences(of: "<[^>;&]+>", with: "", options: .regularExpression, range: nil)
        
        // let cString = desc.cString(using: Unicode.UTF32)
        
        cell.labelDescription.text! = HomeJsonData[indexPath.row].Description.replacingOccurrences(of: "<[^>;&]+>", with: "", options: .regularExpression, range: nil)
        
        
        cell.labelDescription.numberOfLines=3
        
        let imageUrl: String = "http://appybite.com/Vedis/Vedis/Image/"+HomeJsonData[indexPath.row].Image
        
        
        cell.uiImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        
        //   cell.backgroundColor = UIColor(red: 0.1, green: 0.2, blue: 0.3, alpha: 1.5)
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        
        if deviceIdiom == .pad {
            let totalWidth = UIScreen.main.bounds.width
            let cellWidth = totalWidth / 2 - 15.0
            return CGSize(width: cellWidth, height: 280.0)
        }else if deviceIdiom == .phone {
            let totalWidth = UIScreen.main.bounds.width - 15.0
            return CGSize(width: totalWidth, height: 250.0)
        }else if deviceIdiom == .phone {
            return CGSize(width: 500.0, height: 320.0)
        }else {
            return CGSize(width: 400.0, height: 250.0)
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell1:CollectionViewCell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        print("Selected :",cell1.labelTitle.text!)
        
        if cell1.labelTitle.text! == "Reservierung"{
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainstoryboard.instantiateViewController(withIdentifier: "ReservationViewController") as! ReservationViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        if cell1.labelTitle.text! == "Gutschein"{
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainstoryboard.instantiateViewController(withIdentifier: "GutscheinViewController") as! GutscheinViewController
            self.present(vc, animated: true, completion: nil)
        }
        
        if cell1.labelTitle.text! == "Connect"{
            
            let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainstoryboard.instantiateViewController(withIdentifier: "CartDetailViewController") as! CartDetailViewController
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    //json parsing
    
    func JsonDownload() {
        
        let url = URL(string: jsonUrl)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            do {
                
                self.HomeJsonData = try JSONDecoder().decode([HomeData].self, from: data!)
                
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
