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

class TableSegmentView : PASegmentView {
    
    
    @IBOutlet var tableView : UICollectionView!
    
    private var tableDelegate : PACollectionViewDelegate!
    
    override func bind() {
        self.tableView = UICollectionView.init(frame: self.bounds, collectionViewLayout: UICollectionViewFlowLayout.init())
        addSubview(self.tableView)
        
        let controller = getController() as! TableSegmentController
        tableDelegate = PACollectionViewDelegate(TableCellProvider(), controller.sectionSource, getLifecycleOwner(), isPagingEnabled: true)
        tableView.bounds = self.bounds
        tableView.backgroundColor = UIColor.yellow
        tableDelegate.bind(self.tableView)
    }


    
}
