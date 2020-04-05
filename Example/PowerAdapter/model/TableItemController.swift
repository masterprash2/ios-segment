//
//  TableItemController.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 18/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

enum TableItemType : Int, CaseIterable {
    case section
    case content
}

class TableItemController: PAController {
   
    
    
    private (set) var type: TableItemType
    
    private (set) var id: Int
    
    
    init(id : Int, type : TableItemType) {
        self.id = id
        self.type = type
    }
    
    func getType() -> Int {
        return type.rawValue
    }
    
    func getId() -> Int {
        return id
    }
    
    func onCreate(_ itemUpdatePublisher: PAItemUpdatePublisher) {
           
    }
       
    func onDestroy() {
           
    }
    
    func onViewWillAppear() {
        
    }
    
    func onViewWillDisapper() {
        
    }
    
    func isContentEqual(_ rhs: PAController) -> Bool {
        return self.id == rhs.getId()
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
