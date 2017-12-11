//
//  GalleryViewController.swift
//  Berlin
//
//  Created by Bibek on 12/4/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import XLPagerTabStrip

struct jsonData : Decodable {
    let Image : String
}

class GalleryViewController: UIViewController,IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    
    var jsonDatas = [jsonData]()
    
    init(itemInfo: IndicatorInfo) {
        
        self.itemInfo = itemInfo
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo
    
    {
        return itemInfo
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let jsonUrl = "http://appybite.com/Vedis/Vedis/gallery_api.php"
        let url = URL(string: jsonUrl)
        
        print("URL :", url!)
        
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            do {
                
                self.jsonDatas = try JSONDecoder().decode([jsonData].self, from: data!)
              
                for eachImage in self.jsonDatas {
                    
                    print("Image", eachImage.Image)
            
                }
                
            }
            catch {
                
                print("Error")
                
            }
            
            }.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
