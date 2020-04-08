//
//  DataListCell.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 18/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

class DataListCell: PATableViewCell {
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func computeSize(_ parent: UIView) -> CGSize {
        return parent.frame.size
    }
}
