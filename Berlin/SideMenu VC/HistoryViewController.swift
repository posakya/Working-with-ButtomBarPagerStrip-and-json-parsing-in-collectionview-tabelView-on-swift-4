//
//  HistoryViewController.swift
//  Berlin
//
//  Created by Bibek on 12/1/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HistoryViewController:  ButtonBarPagerTabStripViewController{
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        sideMenu()
        // change selected bar color
        settings.style.buttonBarBackgroundColor = UIColor(red:0.14, green:0.64, blue:0.92, alpha:1.0)
        settings.style.buttonBarItemBackgroundColor = UIColor(red:0.14, green:0.64, blue:0.92, alpha:1.0)
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        buttonBarView.selectedBar.backgroundColor = .orange
        buttonBarView.backgroundColor = UIColor(red: 7/255, green: 185/255, blue: 155/255, alpha: 1)
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .white
            newCell?.label.textColor = .white
        }
        super.viewDidLoad()
        // signUpForNotifications()
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
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = TestViewController                                                                            ( itemInfo: "Pending Prayer")
        let child_2 = CategoryViewController(itemInfo: "Duration")
        let child_3 = GalleryViewController(itemInfo: "Feedback")
        return [child_1, child_2, child_3]
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
