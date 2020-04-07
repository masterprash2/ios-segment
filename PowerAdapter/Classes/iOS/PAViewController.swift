//
//  PAViewController.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 06/04/20.
//

import Foundation

open class PAViewController : UIViewController {
    
    private let lifecycleRegistery = PALifecycleRegistry()
    
    func getLifecycleOwner() -> PALifecycle {
        return self.lifecycleRegistery.lifecycle
    }
    
    override open func viewDidLoad() {
        lifecycleRegistery.create()
        super.viewDidLoad()
    }
    
    
    override public func viewWillAppear(_ animated: Bool) {
        self.lifecycleRegistery.viewWillAppear()
        super.viewWillAppear(animated)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        self.lifecycleRegistery.viewDidDisappear()
        super.viewDidDisappear(animated)
    }

}
