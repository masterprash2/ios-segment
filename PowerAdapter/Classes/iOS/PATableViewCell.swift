//
//  File.swift
//  
//
//  Created by Prashant Rathore on 17/02/20.
//

import Foundation
import RxSwift

open class PATableViewCell : UITableViewCell, PAParent {
    
    @IBOutlet public var rootView : PASegmentView?
    
    private var disposeBag = DisposeBag()
    private weak var parentLifecycle : PALifecycle?
    
    private var isInView = false
    
    private weak var parent : PAParent?
    
    
    internal func bind(_ item : PAItemController, _ parent : PAParent) {
        self.parent = parent
        rootView!.bindInternal(self, item)
        self.parentLifecycle = parent.getLifecycle()
        observeParentLifecycle(parentLifecycle!)
    }
    
    private func observeParentLifecycle(_ parentLifcycle : PALifecycle) {
        disposeBag = DisposeBag()
        parentLifecycle?.observeViewState()
            .map({[weak self] (value) -> PALifecycle.State in
                self?.lifecycleUpdates(value)
                return value
            }).subscribe().disposed(by: disposeBag)
    }
    
    
    private func lifecycleUpdates(_ state : PALifecycle.State) {
        switch state {
        case .resume: viewWillAppear()
        case .paused, .destroy: viewDidDisappear()
        default: return
        }
    }
    
    internal func willDisplay() {
        if(!self.isInView) {
            self.isInView = true
            viewWillAppear()
        }
    }
    
    internal func willEndDisplay() {
        if(self.isInView) {
            self.isInView = false
            viewDidDisappear()
        }
    }
    
    private func viewWillAppear() {
        if(self.isInView && self.parentLifecycle?.viewState == PALifecycle.State.resume) {
            self.rootView!.viewWillAppear()
        }
    }
    
    private func viewDidDisappear() {
        self.rootView!.viewDidDisappear()
    }
    
    public func getParent() -> PAParent? {
        return self.parent
    }
    
    public func getLifecycle() -> PALifecycle {
        return parentLifecycle!
    }
    
    public func getRootParent() -> PAParent {
        if(self.parent == nil) {
            return self
        }
        else {
            return self.parent!.getRootParent()
        }
    }
}
