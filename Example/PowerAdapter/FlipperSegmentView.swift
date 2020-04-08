//
//  FlipperSegmentView.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 08/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

class FlipperSegmentView : PASegmentView , PAFlipperDataSource  {
    @IBOutlet var tableView : PAFlipView!
    
    
    private var tableDelegate : PATableDelegate!
    
    override func bind() {
        self.tableView = PAFlipView(frame: self.bounds)
        addSubview(self.tableView)
        
        let controller = getController() as! TableSegmentController
        tableView.bounds = self.bounds
        tableView.backgroundColor = UIColor.yellow
        //        tableDelegate = PATableDelegate(TableCellProvider(), controller.sectionSource, getLifecycleOwner())
        //        // Do any additional setup after loading the view, typically from a nib.
        //        tableView.delegate = tableDelegate
        //        tableView.dataSource = tableDelegate
        //        tableDelegate.bind(self.tableView)
        tableView.setDataSource(self)
    }
    
    func numberOfPagesinFlipper(_ flipView: PAFlipView) -> Int {
        return 100
    }
    
    //    func number(ofPagesinFlipper flipper: ITRFlipper!) -> Int {
    //        return 100
    //    }
    //
    
    func viewForPage(_ flipper: PAFlipView, _ page: Int) -> UIView {
        let view = UILabel()
        view.frame.size = self.bounds.size
        if(page % 2 == 0) {
            view.backgroundColor = UIColor.red
        }
        else {
            view.backgroundColor = UIColor.green
        }
        view.text = "Please note that if your installation fails, it may be because you are installing with a version of Git lower than CocoaPods is expecting. Please ensure that you are running Git >= 1.8.0 by executing git --version. You can get a full picture of the installation details by executing pod install --verbose."
        view.font = UIFont.init(name: "Arial", size: 30)
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        return view
    }
    
    
}
