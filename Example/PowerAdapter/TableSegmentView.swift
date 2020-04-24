//
//  TableSegmentView.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 06/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter
import UIKit

class TableSegmentView : PASegmentView, MSSTabBarViewDataSource {

    
    @IBOutlet var tableView : UICollectionView!
    
    private var tableDelegate : PageDelegateWithTabBar!
    private var tabBar : MSSTabBarView!
    
    override func bind() {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        self.tableView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        addSubview(self.tableView)
        setupTabBar()
        let controller = getController() as! TableSegmentController
        tableDelegate = PageDelegateWithTabBar(TableCellProvider(), controller.tabsSource, self, "MSSTabBarCollectionViewCell" )
        tableView.bounds = self.bounds
        tableView.backgroundColor = UIColor.yellow
        tableDelegate.bind(self.tableView,tabBar)
    }
    
    private func setupTabBar() {
        tabBar = MSSTabBarView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
        addSubview(tabBar)
        tabBar.setDataSource(self, animated: false)
        tabBar.tabStyle = .text
        tabBar.setSizingStyle(.sizeToFit)
    }
    
}

extension TableSegmentView {
    
    func numberOfItems(for tabBarView: MSSTabBarView) -> Int {
        return 4
    }
    
    func tabBarView(_ tabBarView: MSSTabBarView, populateTab tab: MSSTabBarCollectionViewCell, at index: Int) {
    }
    
    
    func tabTitles(for tabBarView: MSSTabBarView) -> [String]? {
        return ["One","Two","-Fout-==","===Three==="]
    }
    
}
