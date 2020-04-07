//
//  PACollectionViewCell.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 07/04/20.
//

import Foundation
import UIKit
import RxSwift

class PACollectionViewCell : UICollectionViewCell {
    
    @IBOutlet var rootView : PASegmentView!
    
    private var lifecycleObserver : Disposable?
    private weak var parentLifecycle : PALifecycle?
    
    private var isInView = false
    
    internal func bind(_ item : PAItemController, _ parentLifecycle : PALifecycle) {
        rootView.bindInternal(item)
        self.parentLifecycle = parentLifecycle
        observeParentLifecycle(parentLifecycle)
    }
    
    private func observeParentLifecycle(_ parentLifcycle : PALifecycle) {
        lifecycleObserver?.dispose()
        lifecycleObserver = parentLifecycle?.observeViewState()
            .map({[weak self] (value) -> PALifecycle.State in
                self?.lifecycleUpdates(value)
                return value
            }).subscribe()
    }
    
    
    private func lifecycleUpdates(_ state : PALifecycle.State) {
        switch state {
        case .resume: viewWillAppear()
        case .paused, .destroy: viewDidDisappear()
        default: return
        }
    }
    
    internal func willDisplay() {
        self.isInView = true
        viewWillAppear()
    }
    
    internal func willEndDisplay() {
        self.isInView = false
        viewDidDisappear()
    }
    
    private func viewWillAppear() {
        if(self.isInView && self.parentLifecycle?.viewState == PALifecycle.State.resume) {
            self.rootView.viewWillAppear()
        }
    }
    
    private func viewDidDisappear() {
        self.rootView.viewDidDisappear()
    }
    
    
}
