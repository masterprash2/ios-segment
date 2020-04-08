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
    
    override func cellForController(_ tableView: UITableView, _ controller: PAController) -> UITableViewCell {
        let cell = super.cellForController(tableView, controller) as! PATableViewCell
        cell.bounds.size = tableView.frame.size
        cell.rootView.bounds.size = tableView.frame.size
        return cell;
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
    
    override func heightForCell(_ tableView: UITableView, _ controller: PAController) -> CGFloat {
        return tableView.frame.size.height
    }
    
    
}
