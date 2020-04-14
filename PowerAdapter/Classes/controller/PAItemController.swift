//
//  PAItemController.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 14/02/20.
//  Copyright © 2020 Prashant Rathore. All rights reserved.
//

import Foundation
import DeepDiff
import RxSwift

public class PAItemController : DiffAware, Hashable {
    
    public static func == (lhs: PAItemController, rhs: PAItemController) -> Bool {
        return lhs.controller.isContentEqual(rhs.controller)
    }
    
    
     public enum State {
        case FRESH
        case CREATE
        case RESUME
        case PAUSE
        case DESTROY
    }

    
    public typealias DiffId = String
     
    public var diffId: String
    public let controller : PAController
    private weak var itemUpdatePublisher : PAItemUpdatePublisher?
    
    private var state = State.FRESH {
        didSet {
            lifecyclePublisher.onNext(self.state)
        }
    }
    private var attachedSources = NSMutableSet()
    
    private let lifecyclePublisher = BehaviorSubject(value: State.FRESH)
    
    public func observeLifecycle() -> Observable<State> {
        return lifecyclePublisher
    }
  
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
    
    func id() ->  String {
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
                self.controller.onViewDidDisapper()
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
