//
//  TableSegmentView.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 06/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

class TableSegmentView : PASegmentView {
    
    @IBOutlet var tableView : UITableView!
    
    
    private var tableDelegate : PATableDelegate!
    
    override func bind() {
        let controller = getController() as! TableSegmentController
        tableDelegate = PATableDelegate(TableCellProvider(), controller.sectionSource, getLifecycleOwner())
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
        tableDelegate.bind(self.tableView)
    }

    
}
