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
    
    override func bind() {
        let segmentContainer = PASegmentViewContainer()
        segmentContainer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width
            , height: self.frame.size.height)
        let view = FlipperSegmentView()
        addSubview(segmentContainer)
        view.frame = CGRect(x: 0, y: 0, width: self.frame.size.width
        , height: self.frame.size.height)
        segmentContainer.bindParent(self)
        segmentContainer.setSegment(PASegment(view,TableSegmentController()))
    }
    
    override func unBind() {
        
    }
    
    
}
