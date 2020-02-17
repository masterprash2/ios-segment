//
//  PSSourceUpdateEventModel.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 14/02/20.
//  Copyright © 2020 Prashant Rathore. All rights reserved.
//

import Foundation
import RxSwift

enum UpdateEventType {
    case updateBegins
    case itemsChanges
    case itemsRemoved
    case itemsAdded
    case itemsMoved
    case updateEnds
    case hasStableIds
}

internal struct PASourceUpdateEventModel  {
    
    let type: UpdateEventType
    let position: Int
    let itemCount: Int
    
    init(type: UpdateEventType, position: Int, itemCount: Int) {
        self.type = type
        self.position = position
        self.itemCount = itemCount
    }

}
