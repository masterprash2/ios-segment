//
//  TableItemController.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 18/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter
import RxSwift

enum TableItemType : Int, CaseIterable {
    case section
    case content
}

class TableItemController: PAController {
    
    private (set) var type: TableItemType
    
    private (set) var id: String
    
    
    
    init(id : Int, type : TableItemType) {
        self.id = id.description
        self.type = type
    }
    
    func getType() -> Int {
        return type.rawValue
    }
    
    func getId() -> String {
        return id
    }
    
    func onCreate(_ itemUpdatePublisher: PAItemUpdatePublisher) {
        NSLog("OnCreate - %d",getId())
    }
    
    
    
    func onViewDidLoad() {
        NSLog("OnloadView - %d",getId())
    }
    
    func onViewWillAppear() {
        NSLog("OnResume - %d",getId())
    }
    
    func onViewDidDisapper() {
        NSLog("OnPause - %d",getId())
    }
    
    func onDestroy() {
        NSLog("OnDestroy - %d",getId())
    }
    
    func onViewDidUnload() {
        NSLog("OnUnloadView - %d",getId())
    }
    
    func isContentEqual(_ rhs: PAController) -> Bool {
        return self.id == rhs.getId()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
