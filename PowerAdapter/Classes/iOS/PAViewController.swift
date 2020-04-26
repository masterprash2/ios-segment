//
//  PAViewController.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 06/04/20.
//

import Foundation
import UIKit
import RxSwift

open class PAViewController : UIViewController, PAParent {
    
    private let lifecycleRegistery = PALifecycleRegistry()
    private var isInView = false
    private let parentLifecycle : PALifecycle? = (UIApplication.shared.delegate as? PAParent)?.getLifecycle()
    private let disposeBag = DisposeBag()
    
    override open func viewDidLoad() {
        lifecycleRegistery.create()
        super.viewDidLoad()
        observeParentLifecycle(parentLifecycle!)
    }
    
    private func observeParentLifecycle(_ parentLifcycle : PALifecycle) {
        parentLifecycle?.observeViewState()
            .map({[weak self] (value) -> PALifecycle.State in
                self?.lifecycleUpdates(value)
                return value
            }).subscribe().disposed(by: disposeBag)
    }
    
    
    private func lifecycleUpdates(_ state : PALifecycle.State) {
        switch state {
        case .resume: viewWillAppearInternal()
        case .paused, .destroy: viewDidDisapperInternal()
        default: return
        }
    }
    
    
    private func viewWillAppearInternal() {
        if(self.isInView && self.parentLifecycle?.viewState ?? .resume == PALifecycle.State.resume) {
            self.lifecycleRegistery.viewWillAppear()
        }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        if(!self.isInView) {
            self.isInView = true
            viewWillAppearInternal()
        }
        super.viewWillAppear(animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        if(self.isInView) {
            self.isInView = false
            viewDidDisapperInternal()
        }
        super.viewDidDisappear(animated)
    }
    
    private func viewDidDisapperInternal() {
        self.lifecycleRegistery.viewDidDisappear()
    }
    
    public func getLifecycle() -> PALifecycle {
        return self.lifecycleRegistery.lifecycle
    }
    
    public func getParent() -> PAParent? {
        return nil
    }
    
    public func getRootParent() -> PAParent {
        return self
    }
    
    
}
