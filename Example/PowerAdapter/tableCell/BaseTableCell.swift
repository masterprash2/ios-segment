//
//  BaseTableCell.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 18/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import PowerAdapter

class BaseTableCell: PASegmentView  {
    
    override func bind(_ item: PAController) {
        NSLog("ONBind")
    }
    
    override func unBind() {
        NSLog("ONUnBind")
    }
    
    
}
