//
//  PASegmentViewContainer.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 09/04/20.
//

import Foundation
import UIKit
import RxSwift

public class PASegmentViewContainer: UIView {
    
    private var parentLifecycle : PALifecycle?
    
    private var segment : PASegment?
    private let disposeBag = DisposeBag()
    private var disposable : Disposable?
    private let itemUpdatePublisher = PAItemUpdatePublisher()
    
    public func bindParentLifecyle(_ lifecycle : PALifecycle) {
        if(parentLifecycle == nil) {
            self.parentLifecycle = lifecycle
        }
    }
    
    public func setSegment(_ segment : PASegment) {
        removeSegment()
        self.segment = segment
        addSubview(segment.segmentView)
        observeLifecycle()
    }
    
    private func observeLifecycle() {
        syncCurrentState()
        self.disposable = self.parentLifecycle!.observeViewState()
            .map {[unowned self] (state) -> PALifecycle.State in
                self.updateLifecycle(state: state)
                return state
        }.subscribe()
    }
    
    private func syncCurrentState() {
        if let segment = self.segment {
            switch self.parentLifecycle!.viewState {
            case .create:
                segment.itemController.performCreate(itemUpdatePublisher)
                segment.segmentView.bindInternal(segment.itemController)
            case .resume:
                segment.itemController.performCreate(itemUpdatePublisher)
                segment.segmentView.bindInternal(segment.itemController)
                segment.segmentView.bindInternal(segment.itemController)
                segment.segmentView.viewWillAppear()
            case .paused:
                segment.itemController.performCreate(itemUpdatePublisher)
                segment.segmentView.bindInternal(segment.itemController)
            default : return
            }
        }
    }
    
    private func updateLifecycle(state : PALifecycle.State) {
        if let segment = self.segment {
            switch state {
            case .create:
                segment.itemController.performCreate(itemUpdatePublisher)
            case .resume:
                segment.segmentView.viewWillAppear()
            case .paused:
                segment.itemController.performCreate(itemUpdatePublisher)
            case .destroy:
                segment.segmentView.viewDidDisappear()
                segment.segmentView.unBind()
                segment.itemController.performDestroy()
            default : return
            }
        }
    }
    
    public func removeSegment() {
        if let segment = self.segment {
            disposable?.dispose()
            disposable = nil
            segment.segmentView.viewDidDisappear()
            segment.segmentView.removeFromSuperview()
            segment.segmentView.unBind()
            segment.itemController.performDestroy()
            self.segment = nil
        }
    }
    
    
    public func unbind() {
        
    }
    
    
    
    
    
}
