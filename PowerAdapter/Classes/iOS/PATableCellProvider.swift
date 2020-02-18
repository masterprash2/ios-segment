//
//  File.swift
//  
//
//  Created by Prashant Rathore on 17/02/20.
//

import Foundation
import UIKit

open class PATableCellProvider<EN : CaseIterable>  {
    
    private let cellTypes : [EN]
    private var cellsRegistered = false
    
    public init(cellTypes : [EN]) {
        self.cellTypes = cellTypes
    }
    
    func registerCells(tableView : UITableView) {
        if(cellsRegistered) {
            return
        }
        cellsRegistered = true
        for value in cellTypes {
            let name = cellNameForID(id: value)
            tableView.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        }
    }
    
    open func cellNameForID(id : EN) -> String {
        preconditionFailure("This method must be overridden")
    }
    
    func cellForId(tableView : UITableView, id : EN) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellNameForID(id: id))!
    }
    
}
