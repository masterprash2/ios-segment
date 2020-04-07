//
//  PACollecionViewDelegate.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 07/04/20.
//

import Foundation
import RxSwift
import UIKit


class PACollectionViewDelegate : NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let cellProvider : PACollectionViewCellProvider
    private let sections : PASectionDatasource
    private let disposeBag = DisposeBag()
    private let parentLifecycle : PALifecycle
    
    public init(_ cellProvider : PACollectionViewCellProvider,_ sections : PASectionDatasource, _ parentLifecycle : PALifecycle) {
        self.cellProvider = cellProvider
        self.sections = sections
        self.parentLifecycle = parentLifecycle
    }
    
    public func bind(_ collectionView : UICollectionView) {
        self.sections.observeSectionUpdateEvents().map {[weak collectionView,weak self] (update) -> Bool in
            if(collectionView != nil) {
                self?.performUpdate(collectionView!, update)
            }
            return true
        }.subscribe().disposed(by: disposeBag)
        self.cellProvider.registerCellsInternal(collectionView)
        self.sections.onAttached()
    }
    
    private func performUpdate(_ collectionView : UICollectionView, _ update : (Int, PASourceUpdateEventModel) ){
        switch update.1.type {
        case .updateBegins: return
//            collectionView.beginUpdates()
        case .itemsChanges:
            collectionView.reloadItems(at: createIndexPathArray(update.0, update.1))
        case .itemsRemoved:
            collectionView.deleteItems(at:  createIndexPathArray(update.0, update.1))
        case .itemsAdded:
            collectionView.insertItems(at:  createIndexPathArray(update.0, update.1))
        case .itemMoved:
            let oldPath = IndexPath(row: update.1.position, section: update.0)
            let newPath = IndexPath(row: update.1.newPosition, section: update.0)
            collectionView.moveItem(at: oldPath, to: newPath)
        case .updateEnds: return
//            collectionView.endUpdates()
        case .sectionMoved:
            collectionView.moveSection(update.1.position, toSection: update.1.newPosition)
        
        }
        
    }
    
    private func createIndexPathArray(_ section : Int,_ update : PASourceUpdateEventModel) -> [IndexPath] {
        var arr = [IndexPath]()
        for i in update.position..<update.position + update.itemCount {
            arr.append(IndexPath.init(row: i, section:section ))
        }
        return arr
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections.numberOfRowsInSection(section)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = itemAtIndexPath(indexPath)
        let cell = self.cellProvider.cellForController(collectionView, item.controller, indexPath)
        let paTableCell = (cell as! PACollectionViewCell)
        paTableCell.bind(item,parentLifecycle)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let tableCell = cell as! PACollectionViewCell
        tableCell.willDisplay()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let tableCell = cell as! PACollectionViewCell
        tableCell.willEndDisplay()
    }
    
    internal func itemAtIndexPath(_ indexPath: IndexPath) -> PAItemController {
        return self.sections.itemAtIndexPath(indexPath)
    }
    
    internal func sectionAtIndex(_ index : Int) -> PAItemController {
        return sections.sectionItemAtIndex(index)
    }
    
    func unBind() {
        sections.onDetached()
    }
    
}
