//
//  PASegmentView.swift
//  DeepDiff
//
//  Created by Prashant Rathore on 06/04/20.
//

import Foundation

open class PASegmentView : UIView {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private var controller : PAItemController!
    
    private var isBounded = false
    
    internal func bindInternal(_ controller : PAItemController) {
        unBindInternal()
        self.isBounded = true
        self.controller = controller
        self.bind(controller.controller)
    }
    
    
    open func bind(_ item : PAController) {
        preconditionFailure("Should override this method")
    }
    
    internal func viewWillAppear() {
        self.controller.performResume()
    }
    
    internal func viewDidDisappear() {
        self.controller.performPause()
    }
    
    func unBindInternal() {
        if(isBounded) {
            self.unBind()
        }
        self.isBounded = false
    }
    
    open func unBind() {
        
    }
    
    
}
