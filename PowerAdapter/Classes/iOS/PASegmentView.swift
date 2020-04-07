//
//  PASegmentView.swift
//  DeepDiff
//
//  Created by Prashant Rathore on 06/04/20.
//

import Foundation
import RxSwift

open class PASegmentView : UIView {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private var itemController : PAItemController!
    
    private var isBounded = false
    
    private let lifecycleRegistry = PALifecycleRegistry()
    private var lifecycleObserver : Disposable?
    
    public func getController() -> PAController {
        return itemController.controller
    }
    
    internal func bindInternal(_ controller : PAItemController) {
        unBindInternal()
        self.isBounded = true
        self.itemController = controller
        observeLifecycle()
        self.bind()
    }
    
    public func getLifecycleOwner() -> PALifecycle {
        return lifecycleRegistry.lifecycle
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
    }
    
    open func unBind() {
        
    }
    
    
}
