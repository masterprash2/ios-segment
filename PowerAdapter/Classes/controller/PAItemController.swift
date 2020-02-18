//
//  PAItemController.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 14/02/20.
//  Copyright © 2020 Prashant Rathore. All rights reserved.
//

import Foundation
import DeepDiff

public protocol PAItemController : DiffAware, Hashable {
    
    associatedtype T : CaseIterable
    
    func onCreate(_ itemUpdatePublisher: PAItemUpdatePublisher)
    func onAttach(source: Any)
    func onDetach(source: Any)
    func onDestroy()
    var type: T { get }
    var id: Int { get }
}
