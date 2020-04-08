//
//  PACollecionViewDelegate.swift
//  PowerAdapter
//
//  Created by Prashant Rathore on 07/04/20.
//

import Foundation
import RxSwift
import UIKit

public protocol PACollectionViewPageDelegate {
    func onPageChanged(_ collectionView : UICollectionView, pagePath: IndexPath)
}

open class PACollectionViewDelegate : NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let cellProvider : PACollectionViewCellProvider
    private let sections : PASectionDatasource
    private let disposeBag = DisposeBag()
    private let parentLifecycle : PALifecycle
    private let isPagingEnabled : Bool
    weak var collectionView : UICollectionView?
    private var currentPage : IndexPath = IndexPath.init(row: 0, section: 0)
    public var pageChangeDelegate : PACollectionViewPageDelegate?
    
    public init(_ cellProvider : PACollectionViewCellProvider,_ sections : PASectionDatasource, _ parentLifecycle : PALifecycle, isPagingEnabled : Bool) {
        self.cellProvider = cellProvider
        self.sections = sections
        self.parentLifecycle = parentLifecycle
        self.isPagingEnabled = isPagingEnabled
    }
    
    public func bind(_ collectionView : UICollectionView) {
        unBind()
        self.collectionView = collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = isPagingEnabled
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
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections.numberOfRowsInSection(section)
    }
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = itemAtIndexPath(indexPath)
        let cell = self.cellProvider.cellForController(collectionView, item.controller, indexPath)
        let paTableCell = (cell as! PACollectionViewCell)
        paTableCell.bind(item,parentLifecycle)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(!self.isPagingEnabled || self.currentPage == indexPath) {
            let tableCell = cell as! PACollectionViewCell
            tableCell.willDisplay()
        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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
        self.collectionView?.dataSource = nil
        self.collectionView?.delegate = nil
        self.collectionView = nil
        sections.onDetached()
    }
    
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentPage()
    }
    
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updateCurrentPage()
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateCurrentPage()
    }
    
    
    private func updateCurrentPage() {
        if(self.isPagingEnabled) {
            if let collectionView = self.collectionView {
                let center = CGPoint(x: collectionView.contentOffset.x + (collectionView.frame.width / 2), y: collectionView.contentOffset.y + (collectionView.frame.height / 2))
                if let ip = collectionView.indexPathForItem(at: center) {
                    if(self.currentPage != ip) {
                        setCurrentPage(collectionView, ip)
                    }
                }
            }
        }
    }
    
    private func setCurrentPage(_ collectionView : UICollectionView, _ ip : IndexPath) {
        let oldCell = collectionView.cellForItem(at: self.currentPage)
        (oldCell as? PACollectionViewCell)?.willEndDisplay()
        self.currentPage = ip
        let newCell = collectionView.cellForItem(at: self.currentPage)
        (newCell as? PACollectionViewCell)?.willDisplay()
        self.pageChangeDelegate?.onPageChanged(collectionView, pagePath: ip)
    }
    
    
    
    
}
