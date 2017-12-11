//
//  OfferViewController.swift
//  Berlin
//
//  Created by Bibek on 12/4/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit

class OfferViewController: UIViewController {

   // @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var views: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu()
        
//        views = [UIView]()
//         views.append(SubHomeViewController().view)
//         views.append(CategoryViewController().view)
//         views.append(GalleryViewController().view)
//         views.append(InfoViewController().view)
//        
//        for v in views {
//            viewContainer.addSubview(v)
//        }
//        
//        viewContainer.bringSubview(toFront: views[0])
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        self.viewContainer.bringSubview(toFront: views[sender.selectedSegmentIndex])
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
