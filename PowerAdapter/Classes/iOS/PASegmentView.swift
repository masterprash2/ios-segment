//
//  PASegmentView.swift
//  DeepDiff
//
//  Created by Prashant Rathore on 06/04/20.
//

import Foundation
import RxSwift
import RxCocoa

open class PASegmentView : UIView, PAParent {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    private var itemController : PAItemController!
    
    private var isBounded = false
    
    private let lifecycleRegistry = PALifecycleRegistry()
    private var lifecycleObserver : Disposable?
    
    private weak var parent : PAParent?
    
    public func getController() -> PAController {
        return itemController.controller
    }
    
    internal func bindInternal(_ parent : PAParent, _ controller : PAItemController) {
        self.parent = parent
        unBindInternal()
        self.isBounded = true
        self.itemController = controller
        observeLifecycle()
        self.bind()
    }
    
    open func bind() {
        preconditionFailure("Should override this method")
    }
    
    private func observeLifecycle() {
        lifecycleObserver = itemController.observeLifecycle().map {[weak self] (state) -> PAItemController.State in
            self?.updateLifecycle(state: state)
            return state
        }.subscribe()
    }
    
    private func updateLifecycle(state : PAItemController.State) {
        switch state {
        case .CREATE: lifecycleRegistry.create()
        case .RESUME: lifecycleRegistry.viewWillAppear()
        case .PAUSE: lifecycleRegistry.viewDidDisappear()
        case .DESTROY: lifecycleRegistry.destroy()
        default : return
        }
    }
    
    internal func viewWillAppear() {
        self.itemController.performResume()
    }
    
    internal func viewDidDisappear() {
        self.itemController.performPause()
    }
    
    func unBindInternal() {
        lifecycleObserver?.dispose()
        if(isBounded) {
            self.unBind()
        }
        self.isBounded = false
        self.parent = nil
    }
    
    open func unBind() {
        
    }
    
    
    public func getParent() -> PAParent? {
        return self.parent
    }
    
    public func getLifecycle() -> PALifecycle {
        return lifecycleRegistry.lifecycle
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
