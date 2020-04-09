//
//  PAViewController.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 06/04/20.
//

import Foundation
import UIKit

open class PAViewController : UIViewController {
    
    private let lifecycleRegistery = PALifecycleRegistry()
    
    public func getLifecycleOwner() -> PALifecycle {
        return self.lifecycleRegistery.lifecycle
    }
    
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

}
