//
//  LocationViewController.swift
//  Berlin
//
//  Created by Bibek on 12/1/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenu()
        
       
        
//        view.backgroundColor = UIColor.green
//        self.title = "Location"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenu(){
        if revealViewController() != nil {
            menuButton.target=revealViewController()
            menuButton.action=#selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
       
    
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
