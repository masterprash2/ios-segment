//
//  PAProxySource.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 19/02/20.
//

import Foundation

class PAProxySource<T : CaseIterable, Controller : PAItemController> : PAItemControllerSource<T,Controller> {
    
    
    func updateIndexes(_ modifiedItem: PAAdapterAsItem<T, Controller>) {
        preconditionFailure("Should override this method")
    }
    
}
