//
//  FlipperSegmentView.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 08/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

class FlipperSegmentView : PASegmentView   {
    
    @IBOutlet var tableView : PAFlipperView!
    
    private var flipperDelegate : PAFlipperViewPageSourceAndDelegate!
    
//    private var tableDelegate : PATableDelegate!
    
    override func bind() {
        self.tableView = PAFlipperView(frame: self.bounds)
        addSubview(self.tableView)
        let controller = getController() as! TableSegmentController
        tableView.bounds = self.bounds
        flipperDelegate = PAFlipperViewPageSourceAndDelegate(FlipperSegmentProvider(),controller.pageSource , self)
        flipperDelegate.bind(tableView)
    }
    
}
