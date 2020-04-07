//
//  ViewController.swift
//  PowerAdapter
//
//  Created by masterprash2 on 02/18/2020.
//  Copyright (c) 2020 masterprash2. All rights reserved.
//

import UIKit
import PowerAdapter

class ViewController: PASegmentViewController {
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    
    override func createController() -> PAController {
        return TableSegmentController()
    }
    

}

