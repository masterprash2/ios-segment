//
//  PAViewController.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 06/04/20.
//

import Foundation
import UIKit

open class PAViewController : UIViewController, PAParent {
    
    private let lifecycleRegistery = PALifecycleRegistry()
    
    override open func viewDidLoad() {
        lifecycleRegistery.create()
        super.viewDidLoad()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        self.lifecycleRegistery.viewWillAppear()
        super.viewWillAppear(animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        self.lifecycleRegistery.viewDidDisappear()
        super.viewDidDisappear(animated)
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
