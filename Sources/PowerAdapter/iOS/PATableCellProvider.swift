//
//  File.swift
//  
//
//  Created by Prashant Rathore on 17/02/20.
//

import Foundation
import UIKit

class PATableCellProvider<EN : CaseIterable>  {
    
    private let cellTypes : [EN]
    private var cellsRegistered = false
    
    init(cellTypes : [EN]) {
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
    
    func cellNameForID(id : EN) -> String {
        return nil!
    }
    
    func cellForId(tableView : UITableView, id : EN) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cellNameForID(id: id))!
    }
    
}
