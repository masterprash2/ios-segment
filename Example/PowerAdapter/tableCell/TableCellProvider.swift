//
//  TableCellProvider.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 18/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

class TableCellProvider : PATableCellProvider {
    
    
    override func registerCells(_ tableView: UITableView) {
        TableItemType.allCases.forEach { (type) in
            let name = cellNameForType(type)
            tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        }
    }
    
    override func cellNameForController(_ controller: PAController) -> String {
        return cellNameForType(TableItemType(rawValue: controller.getType())!)
    }
    
    func cellNameForType(_ type: TableItemType) -> String {
        switch type {
        case .content:
            return "DataListCell"
        case .section:
            return "DataListCell"
        }
    }
    
    
}
