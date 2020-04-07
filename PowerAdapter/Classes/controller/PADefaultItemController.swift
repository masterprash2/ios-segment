//
//  PADefaultItemController.swift
//  presenter
//
//  Created by Prashant Rathore on 07/04/20.
//  Copyright © 2020 TIL. All rights reserved.
//

import Foundation

public class PADefaultItemController: PAController {
    
    private let id : Int
    private let type : Int
    
    public init(_ id : Int, _ type : Int) {
        self.id = id
        self.type = type
    }
    
    public func getType() -> Int {
        return type
    }
    
    public func getId() -> Int {
        self.id
    }
    
    public func onCreate(_ itemUpdatePublisher: PAItemUpdatePublisher) {
        
    }
    
    public func onViewWillAppear() {
        
    }
    
    public func onViewDidDisapper() {
        
    }
    
    public func onDestroy() {
        
    }
    
    public func isContentEqual(_ rhs: PAController) -> Bool {
        return false
    }
    
    public func hash(into hasher: inout Hasher) {
        
    }
    
    
}
