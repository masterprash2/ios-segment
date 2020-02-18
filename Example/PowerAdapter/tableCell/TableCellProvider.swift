//
//  TableCellProvider.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 18/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

class TableCellProvider : PATableCellProvider<TableItemType> {
    
    init() {
        super.init(cellTypes: TableItemType.allCases)
    }
    
    override func cellNameForID(id: TableItemType) -> String {
        switch id {
        case .content:
            return "DataListCell"
        case .section:
            return "DataListCell"
        }
    }
    
    
}
