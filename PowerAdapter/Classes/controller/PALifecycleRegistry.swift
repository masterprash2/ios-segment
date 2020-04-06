//
//  PALifecycleRegistry.swift
//  DeepDiff
//
//  Created by Prashant Rathore on 05/04/20.
//

import Foundation
import RxSwift

public class PALifecycleRegistry {
    
    
    public let lifecycle = PALifecycle()
    
    public init() {
        
    }
   
    
    public func create() {
        switch lifecycle.viewState {
            case .initialized,.create : self.lifecycle.setViewState(state: .create);
            default : return
        }
        
    }
    
    public func viewWillAppear() {
        create()
        switch lifecycle.viewState {
            case .create,.paused : self.lifecycle.setViewState(state: .resume);
            default : return
        }
    }
    
    public func viewDidDisappear() {
        create()
        switch lifecycle.viewState {
            case .resume : self.lifecycle.setViewState(state: .paused);
            default : return
        }
    }
    
    public func destroy() {
        viewWillAppear()
        self.lifecycle.setViewState(state: .destroy);
    }
    
}
