//
//  PAItemController.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 14/02/20.
//  Copyright © 2020 Prashant Rathore. All rights reserved.
//

import Foundation
import DeepDiff

public class PAItemController : DiffAware, Hashable {
    
    public static func == (lhs: PAItemController, rhs: PAItemController) -> Bool {
        return lhs.controller.isContentEqual(rhs.controller)
    }
    
    
     enum State {
        case FRESH
        case CREATE
        case RESUME
        case PAUSE
        case DESTROY
    }

    
    public typealias DiffId = Int
     
    public var diffId: Int
    let controller : PAController
    private weak var itemUpdatePublisher : PAItemUpdatePublisher?
    
    private (set) var state = State.FRESH
    private var attachedSources = NSMutableSet()
  
    init(_ controller : PAController) {
        self.controller = controller
        self.diffId = controller.getId()
    }

    
    public func hash(into hasher: inout Hasher) {
        controller.hash(into: &hasher)
    }
    
    func type() -> Int {
        return controller.getType()
    }
    
    func id() ->  Int {
        return controller.getId()
    }
    
    public static func compareContent(_ a: PAItemController, _ b: PAItemController) -> Bool {
        return a.controller.isContentEqual(b.controller)
    }
    
    func performCreate(_ itemUpdatePublisher: PAItemUpdatePublisher) {
        self.itemUpdatePublisher = itemUpdatePublisher
        switch (state) {
            case .FRESH,.DESTROY : do {
                self.state = .CREATE
                controller.onCreate(self.itemUpdatePublisher!)
            }
            default: return
        }
    }
    
    
    func performResume() {
        performCreate(self.itemUpdatePublisher!)
        switch (state) {
            case .PAUSE,.CREATE : do {
                self.state = .RESUME
                self.controller.onViewWillAppear()
            }
            default: return
        }

    }

    func performPause() {
        switch (state) {
            case .RESUME : do {
                self.state = .PAUSE
                self.controller.onViewWillDisapper()
            }
            default: return
        }
    }


    func performDestroy() {
        switch (state) {
            case .RESUME : do {
                performPause()
                self.state = .DESTROY
                self.controller.onDestroy()
            }
            case .CREATE, .PAUSE : do {
                self.state = .DESTROY
                self.controller.onDestroy()
            }
            default: return
        }
           
    }
}
