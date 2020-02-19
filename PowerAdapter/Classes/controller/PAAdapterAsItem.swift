//
//  PAAdapterAsItem.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 19/02/20.
//

import Foundation
import RxSwift

class PAAdapterAsItem<T : CaseIterable, Controller : PAItemController> {
    
    let adapter: PAItemControllerSource<T, Controller>
    var startPosition = 0
    var updateObserver: Disposable!
    weak var parent : PAProxySource<T,Controller>?
    
    init(adapter: PAItemControllerSource<T, Controller>,
         parent : PAProxySource<T,Controller>) {
        self.adapter = adapter
        self.parent = parent
        DispatchQueue.main.async {
            self.subscribeUpdates()
        }
    }
    
    private func subscribeUpdates() {
        updateObserver = adapter.observeAdapterUpdates().map({[unowned self] (event) -> Bool in
            self.transformUpdateEvent(event)
            return true
        }).subscribe()
    }
    
    func transformUpdateEvent(_ event: PASourceUpdateEventModel) {
        let actualStartPosition = startPosition + event.position
        switch (event.type) {
        case .updateBegins : parent?.beginUpdates()
        case .itemsChanges : parent?.notifyItemsChanged(actualStartPosition, itemCount: event.itemCount)
        case .itemsRemoved : parent?.notifyItemsRemoved(actualStartPosition, event.itemCount)
        case .itemsAdded : parent?.notifyItemsInserted(actualStartPosition, event.itemCount)
        case .itemMoved : parent?.notifyItemMoved(actualStartPosition, newPosition: event.newPosition)
        case .updateEnds : parent?.endUpdates()
        case .sectionMoved: preconditionFailure("This is invalid call")
        }
        parent?.updateIndexes(self)
    }

    
}
