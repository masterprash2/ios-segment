//
//  PageDelegateWithTabBar.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 21/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

public class PageDelegateWithTabBar : PACollectionPageViewDelegate, MSSTabBarViewDataSource, MSSTabBarViewDelegate {
    
    private let tabCellNib : String
    private let tabsSource : PAArraySource
    
    public init(_ cellProvider: PACollectionViewCellProvider,
                  _ tabsSource: PAArraySource,
                  _ parent: PAParent,
                  _ tabCellNibName : String) {
        self.tabsSource = tabsSource
        self.tabCellNib = tabCellNibName
        let sectionSource = PASectionDatasource()
        sectionSource.addSection(item: PADefaultItemController(1,1), source: tabsSource)
        super.init(cellProvider, sectionSource, parent)
    }

    weak var tabBar : MSSTabBarView? {
        didSet {
            self.tabBar?.delegate = self
            self.tabBar?.dataSource = self
            self.tabBar?.cellNibName = tabCellNib
            self.tabBar?.reloadData()
        }
    }
    
    override public func bind(_ collectionView: UICollectionView) {
        preconditionFailure("Usear bind")
    }
    
    open func bind(_ collectionView: UICollectionView, _ tabBar : MSSTabBarView ) {
        self.tabBar = tabBar
        super.bind(collectionView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let x = scrollView.contentOffset.x
        tabBar?.tabOffset = CGFloat(x) / width
    }
    
    public override func currentPage(_ collectionView: UICollectionView, current page: IndexPath) {
        self.tabBar?.setTabIndex(page.row, animated: true)
    }
    
    public override func updateEnds() {
        self.tabBar?.reloadData()
    }
    
}

extension PageDelegateWithTabBar {
    
    public func numberOfItems(for tabBarView: MSSTabBarView) -> Int {
        return tabsSource.itemCount
    }
    
    public func tabTitles(for tabBarView: MSSTabBarView) -> [String]? {
        return tabsSource.items().map { (value) -> String in
                "Tab " + value.controller.getId()
            }
    }
    
    public func tabBarView(_ tabBarView: MSSTabBarView, populateTab tab: MSSTabBarCollectionViewCell, at index: Int) {
        
    }
    
    public func tabBarView(_ tabBarView: MSSTabBarView, tabSelectedAt index: Int) {
        super.collectionView?.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    
}
