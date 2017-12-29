//
//  SetAnimation.swift
//  Berlin
//
//  Created by Bibek on 12/13/17.
//  Copyright © 2017 Bibek. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

struct SetAnimation{
    
    struct forDataFetching{
        
        static func startAnimation(){
            let activityData = ActivityData()
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
        }
        
        static func stopAnimation(){
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        }
    }
    
}
