//
//  TableItemController.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 18/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

enum TableItemType : CaseIterable {
    case content
}

class TableItemController: PAItemController {
    
    typealias T = TableItemType
    
    private (set) var type: TableItemType
    
    private (set) var id: Int32
    
    
    init(id : Int32, type : TableItemType) {
        self.id = id
        self.type = type
    }
    
    func onCreate(_ itemUpdatePublisher: PAItemUpdatePublisher) {
        
    }
    
    func onAttach(source: Any) {
    
    }
    
    func onDetach(source: Any) {
    
    }
    
    func onDestroy() {
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    
    static func == (lhs: TableItemController, rhs: TableItemController) -> Bool {
        return true
    }
    
    
    
}
