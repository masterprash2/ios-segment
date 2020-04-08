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
    
    
    @IBOutlet var tableView : UITableView!
    
    private var tableDelegate : PATableDelegate!
    
    override func bind() {
        self.tableView = UITableView(frame: self.bounds)
        addSubview(self.tableView)
        
        let controller = getController() as! TableSegmentController
        tableDelegate = PATableDelegate(TableCellProvider(), controller.sectionSource, getLifecycleOwner(), true)
        tableView.bounds = self.bounds
        tableView.backgroundColor = UIColor.yellow
        tableDelegate.bind(self.tableView)
    }


    
}
