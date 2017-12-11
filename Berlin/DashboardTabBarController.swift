//
//  DashboardTabBarController.swift
//  Berlin
//
//  Created by Bibek on 12/3/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import Foundation

class DashboardTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var tabFrame:CGRect = self.tabBar.frame
        tabFrame.origin.y = self.view.frame.origin.y
        self.tabBar.frame = tabFrame
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let item1 = HistoryViewController()
        let item2 = Item1ViewController()
        let icon1 = UITabBarItem(title: "Title", image: UIImage(named: "ic_home.png"), selectedImage: UIImage(named: "history.png"))
        let icon2 = UITabBarItem(title: "Title", image: UIImage(named: "cart.png"), selectedImage: UIImage(named: "history.png"))
        item1.tabBarItem = icon1
        item2.tabBarItem = icon2
        let controllers = [item1, item2]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers
        self.selectedIndex = 0
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(String(describing: viewController.title)) ?")
        return true;
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
