//
//  OfferViewController.swift
//  Berlin
//
//  Created by Bibek on 12/4/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit

class OfferViewController: UIViewController {
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        sideMenu()
        
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
    
    
    
}
