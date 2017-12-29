//
//  GalleryViewController.swift
//  Berlin
//
//  Created by Bibek on 12/4/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SDWebImage

struct jsonData : Decodable {
    let Image : String
}

class GalleryViewController: UIViewController,IndicatorInfoProvider {
    
    @IBOutlet weak var scrollView: UIScrollView!
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
        
        
        SetAnimation.forDataFetching.startAnimation()
        
        scrollView.frame = view.frame
        
        let jsonUrl = "http://appybite.com/Vedis/Vedis/gallery_api.php"
        let url = URL(string: jsonUrl)
        
        print("URL :", url!)
        
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            do {
                
                SetAnimation.forDataFetching.stopAnimation()
                
                self.jsonDatas = try JSONDecoder().decode([jsonData].self, from: data!)
                
                print("Array ", self.jsonDatas.count)
                
                for i in 0..<self.jsonDatas.count {
                    
                    
                    let imageView = UIImageView()
                    let xPos = self.view.frame.width * CGFloat(i)
                    let imageUrl: String = "http://appybite.com/Vedis/Vedis/Image/"+self.jsonDatas[i].Image
                    print("DownloadImage",imageUrl)
                    imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
                    imageView.contentMode = .scaleAspectFit
                    imageView.frame = CGRect(x: xPos, y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
                    
                    self.scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(i + 1)
                    self.scrollView.addSubview(imageView)
                    
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
