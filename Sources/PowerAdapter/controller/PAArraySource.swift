//
//  File.swift
//  
//
//  Created by Prashant Rathore on 17/02/20.
//

import Foundation
import RxSwift
import DeepDiff

class PAArraySource<T : CaseIterable, Controller : PAItemController> : PAItemControllerSource<T, Controller> {
    
    private var controllers = [Controller]()
    private var isAttached = false
    private let itemUpdatePublisher = PAItemUpdatePublisher()
    private var disposeBag : DisposeBag?
    
    override func onAttached() {
        isAttached = true
        disposeBag = DisposeBag()
        observeItemUpdates().disposed(by: disposeBag!)
        for item in controllers {
            item.onCreate(itemUpdatePublisher)
        }
    }
    
    override func onItemAttached(position: Int) {
        
    }
    
    func items() -> [Controller] {
        return controllers
    }
    
    
    func setItems(_ items: [Controller]?) {
        switchItems(items)
    }
    
    private func switchItems(_ items:  [Controller]?, useDiffProcess: Bool) {
        var newItems = (items != nil) ? items! : [Controller]()
        processWhenSafe { switchItemImmediate(useDiffProcess, &newItems) }
    }
    
    private func switchItemImmediate(_ useDiffProcess: Bool,_ newItems: inout [Controller]) {
        let oldCount = controllers.count
        let newCount = newItems.count
        let retained = Set<Controller>()
        
        let diffResult = diff(old: controllers, new: newItems)
//        diffResult.
        var oldItems = controllers
        controllers = newItems
        beginUpdates()
        if (useDiffProcess) {
//            diffResult.dispatchUpdatesTo(self)
        } else {
            let diff = newCount - oldCount
            if (diff > 0) {
                notifyItemsInserted(oldCount, diff)
                notifyItemsChanged(startIndex: 0, itemCount: oldCount)
            } else if (diff < 0) {
                notifyItemsRemoved(newCount, diff * -1)
                notifyItemsChanged(startIndex: 0, itemCount: newCount)
            } else {
                notifyItemsChanged(startIndex: 0, itemCount: newCount)
            }
        }
        endUpdates()
        if (isAttached) {
            for item in newItems {
                item.onCreate(itemUpdatePublisher)
            }
        }
        
        oldItems.removeAll { (item) -> Bool in
            return retained.contains(item)
        }
        
        for item in oldItems {
            item.onDestroy()
        }
    }
    
    func switchItems(_ items: [Controller]?) {
        switchItems(items, useDiffProcess: false)
    }
    
    func switchItemsWithDiffRemovalAndInsertions(_ items: [Controller]?) {
        switchItems(items, useDiffProcess: true)
    }
    
//    private func diffResults(_ oldItems: List<Controller>,_ newItems: MutableList<Controller>, retained: inout Set<Controller>): DiffUtil.DiffResult {
//        return DiffUtil.calculateDiff(object : DiffUtil.Callback() {
//            override fun getOldListSize(): Int {
//                return oldItems.size
//            }
//
//            override fun getNewListSize(): Int {
//                return newItems.size
//            }
//
//            override fun areItemsTheSame(oldPosition: Int, newPosition: Int): Boolean {
//                val itemOld = oldItems[oldPosition]
//                val itemNew = newItems[newPosition]
//                val equals = itemOld === itemNew || itemOld.hashCode() == itemNew.hashCode() && itemOld == itemNew
//                if (equals) {
//                    newItems[newPosition] = itemOld
//                    retained.add(itemOld)
//                }
//                return equals
//            }
//
//            override fun areContentsTheSame(oldPosition: Int, newPosition: Int) -> Boolean {
//                return areItemsTheSame(oldPosition, newPosition)
//            }
//        }, false)
//    }
    
    func replaceItem(_ index: Int, _ item: Controller) {
        processWhenSafe{ replaceItemWhenSafe(index, item) }
    }
    
    private func replaceItemWhenSafe(_ index: Int,_ item: Controller) {
        let old = controllers[index]
        controllers[index] = item
        old.onDestroy()
        notifyItemsChanged(startIndex: index, itemCount: 1)
        if (isAttached) {
            item.onCreate(itemUpdatePublisher)
        }
    }
    
    override func getItemPosition(_ item: Controller) -> Int {
        return controllers.firstIndex(of: item) ?? -1
    }
    
    
    override func computeItemCount() -> Int {
        return controllers.count
    }
    
    override func getItemForPosition(_ position: Int) -> Controller {
        return controllers[position]
    }
    
    //    @Override
    //    public void onItemDetached(int position) {
    //
    //    }
    private func observeItemUpdates() -> Disposable {
        return itemUpdatePublisher.observeEvents().map({[weak self] (it) -> Any in
            self?.postItemUpdate(it)
            return it
        }).subscribe()
    }
    
    private func postItemUpdate(_ itemController: Any) {
        processWhenSafe{
            let index = self.controllers.firstIndex(of: itemController as! Controller)
            if (index ?? -1 >= 0) {
                notifyItemsChanged(startIndex: index!, itemCount: 1)
            }
        }
    }
    
    override func onDetached() {
        disposeBag = nil
        isAttached = false
        for cn in controllers {
            cn.onDestroy()
        }
    }
    
    
}
