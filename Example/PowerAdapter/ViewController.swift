//
//  ViewController.swift
//  PowerAdapter
//
//  Created by masterprash2 on 02/18/2020.
//  Copyright (c) 2020 masterprash2. All rights reserved.
//

import UIKit
import PowerAdapter

class ViewController: PAViewController {
    
    @IBOutlet var segmentContainer : PASegmentViewContainer!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentContainer.bindParent(self)
        let view = FlipperSegmentView(frame: CGRect(x: 0, y: 0, width: self.segmentContainer.frame.size.width, height: self.segmentContainer.frame.size.height))
//        segmentContainer.setSegment(PASegment(view,TableSegmentController()))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let view = TableSegmentView(frame: CGRect(x: 0, y: 0, width: self.segmentContainer.frame.size.width, height: self.segmentContainer.frame.size.height))
        
        segmentContainer.setSegment(PASegment(view,TableSegmentController()))
    }
    
    
    
    
//    override func createController() -> PAController {
//        return TableSegmentController()
//    }
    

}

