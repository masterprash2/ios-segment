//
//  PageDelegateWithTabBar.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 21/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

class PageDelegateWithTabBar : PACollectionPageViewDelegate {
    
    weak var tabBar : MSSTabBarView?
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let x = scrollView.contentOffset.x
        tabBar?.tabOffset = CGFloat(x) / width
    }
    
    
}
