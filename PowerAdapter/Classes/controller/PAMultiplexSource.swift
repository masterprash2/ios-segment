//
//  PAProxySource.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 19/02/20.
//

import Foundation
import RxSwift


/**
 * Created by prashant.rathore on 24/06/18.
 */
public class PAMultiplexSource : PAProxySource {
    
    private var adapters = [PAAdapterAsItem]()
    private var isAttached = false
    
    public override init() {
        
    }
    
    
    override func onAttached() {
        isAttached = true
        for item in adapters {
            item.adapter.onAttached()
        }
    }

    override public var viewInteractor: ViewInteractor? {
        didSet {
            adapters.forEach({ (it) in
                it.adapter.viewInteractor = viewInteractor
            })
        }
    }


    override func onItemAttached(position: Int) {
        let adapterAsItem = decodeAdapterItem(position)
        adapterAsItem.adapter.onItemAttached(position: position - adapterAsItem.startPosition)
    }


    public func addSource(adapter: PAItemControllerSource) {
        insertSource(adapters.count, adapter)
    }

    public func insertSource(_ index: Int, _  adapter: PAItemControllerSource) {
        let item = PAAdapterAsItem(adapter: adapter,parent: self)
        adapter.viewInteractor = viewInteractor
        processWhenSafe{ addSourceImmediate(index, item) }
    }

    private func addSourceImmediate(_ index: Int,_ item: PAAdapterAsItem) {
        if (adapters.count > index) {
            let previousItem = adapters[index]
            item.startPosition = previousItem.startPosition
        } else if (adapters.count > 0) {
            let lastItem = adapters[adapters.count - 1]
            item.startPosition = lastItem.startPosition + lastItem.adapter.itemCount
        }
        adapters.insert(item,at: index)
        updateIndexes(item)
        if (isAttached) {
            item.adapter.onAttached()
        }
        beginUpdates()
        notifyItemsInserted(item.startPosition, item.adapter.itemCount)
        endUpdates()
    }

    override func computeItemCount() -> Int {
        if (adapters.count > 0) {
            let item = adapters[adapters.count - 1]
            return item.startPosition + item.adapter.itemCount
        }
        return 0
    }

    override func getItemForPosition(_ position: Int) -> PAItemController {
        let item = decodeAdapterItem(position)
        return item.adapter.getItem(position - item.startPosition)
    }

    //    @Override
//    public void onItemDetached(int position) {
//        AdapterAsItem adapterAsItem = decodeAdapterItem(position);
//        adapterAsItem.adapter.onItemDetached(position - adapterAsItem.startPosition);
//    }
    override func onDetached() {
        for item in adapters {
            item.adapter.onDetached()
        }
        isAttached = false
    }

    private func decodeAdapterItem(_ position: Int) -> PAAdapterAsItem {
        var previous: PAAdapterAsItem!
        for adapterAsItem in adapters {
            if (adapterAsItem.startPosition > position) {
                return previous
            } else {
                previous = adapterAsItem
            }
        }
        return previous
    }

    override func getItemPosition(_ item: PAItemController) -> Int {
        let top = 0
        var itemPosition = -1
        for adapterAsItem in adapters {
            let foundPosition = adapterAsItem.adapter.getItemPosition(item)
            if (foundPosition >= 0) {
                itemPosition = top + foundPosition
                break
            }
        }
        return itemPosition
    }

    public func removeAdapter(_ removeAdapterAtPosition: Int) {
        processWhenSafe{ removeAdapterImmediate(removeAdapterAtPosition) }
    }

    private func removeAdapterImmediate(_ removeAdapterAtPosition: Int) {
        let remove: PAAdapterAsItem = adapters.remove(at: removeAdapterAtPosition)
        let removePositionStart = remove.startPosition
        var nextAdapterStartPosition = removePositionStart
        for index in removeAdapterAtPosition..<adapters.count {
            let adapterAsItem = adapters[index]
            adapterAsItem.startPosition = nextAdapterStartPosition
            nextAdapterStartPosition = adapterAsItem.startPosition + adapterAsItem.adapter.itemCount
        }
        beginUpdates()
        notifyItemsRemoved(removePositionStart, remove.adapter.itemCount)
        endUpdates()
        remove.adapter.viewInteractor = nil
    }

    override func updateIndexes(_ modifiedItem: PAAdapterAsItem) {
        var modifiedItem = modifiedItem
        var continueUpdating = false
        for item in adapters {
            if (continueUpdating) {
                item.startPosition = modifiedItem.startPosition + modifiedItem.adapter.itemCount
                modifiedItem = item
            } else if (item === modifiedItem) {
                continueUpdating = true
            }
        }
    }
}
