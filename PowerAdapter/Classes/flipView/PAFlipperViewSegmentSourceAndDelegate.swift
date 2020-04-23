//
//  PAFlipperViewPageSourceAndDelegate.swift
//  DeepDiff
//
//  Created by Prashant Rathore on 17/04/20.
//

import Foundation
import RxSwift

public class PAFlipperViewPageSourceAndDelegate : PAFlipperViewDataSource, PAFlipperViewPageDelegate  {
    
    
    
    private let viewProvider : PASegmentViewProvider
    private let itemSource : PAItemControllerSource
    private let disposeBag = DisposeBag()
    private let parentLifecycle : PALifecycle
    weak var flipperView : PAFlipperView?
    private var currentPage : Int = 0
    public weak var pageChangeDelegate : PAFlipperViewPageDelegate?
    private weak var parent : PAParent?
    private var primaryItem : PASegmentView?
    
    
    public init(_ viewProvider : PASegmentViewProvider, _ itemSource : PAItemControllerSource, _ parent : PAParent) {
        self.viewProvider = viewProvider
        self.itemSource = itemSource
        self.parent = parent
        self.parentLifecycle = parent.getLifecycle()
    }
    
    public func bind(_ flipperView : PAFlipperView) {
        unBind()
        self.flipperView = flipperView
        flipperView.delegate = self
        flipperView.dataSource = self
        self.itemSource.observeAdapterUpdates().map {[weak flipperView,weak self] (update) -> Bool in
            if(flipperView != nil) {
                //                self?.performUpdate(tableView!, update)
            }
            return true
        }.subscribe().disposed(by: disposeBag)
        self.itemSource.onAttached()
    }
    
    
    private func createIndexPathArray(_ section : Int,_ update : PASourceUpdateEventModel) -> [IndexPath] {
        var arr = [IndexPath]()
        for i in update.position..<update.position + update.itemCount {
            arr.append(IndexPath.init(row: i, section:section ))
        }
        return arr
    }
    
    public func numberOfPagesinFlipper(_ flipperView: PAFlipperView) -> Int {
        return  self.itemSource.itemCount
    }
    
    func viewForPage(_ flipper: PAFlipperView, _ page: Int) -> UIView {
        let pageController = itemAtIndexPath(page)
        return viewProvider.segmentViewForType(flipper, pageController.type())
    }
    
    
    public func flipperView(_ flipperView : PAFlipperView, loadPageAt index: Int) -> UIView {
        let item = itemAtIndexPath(index)
        let page = self.viewProvider.segmentViewForType(flipperView, item.controller.getType())
        page.bindInternal(parent!, item)
        return page
    }
    
    
    public func flipperView(_ flipperView: PAFlipperView, willDisplay page: UIView, at index: Int) {
        if(self.currentPage == index) {
            let tableCell = page as! PASegmentView
            tableCell.viewWillAppear()
            self.primaryItem = tableCell
        }
    }
    
    public func flipperView(_ flipperView : PAFlipperView, didEndDisplaying page: UIView, at index: Int) {
        let tableCell = page as! PASegmentView
        tableCell.viewDidDisappear()
        if(self.currentPage == index) {
            self.currentPage = -1
            self.primaryItem = nil
        }
    }
    
    public func flipperView(_ flipperView: PAFlipperView, willUnload page: UIView, at index: Int) {
        let tableCell = page as! PASegmentView
        tableCell.unBindInternal()
    }
    
    
    public func itemAtIndexPath(_ index: Int) -> PAItemController {
        return self.itemSource.getItem(index)
    }
    
    
    
    func unBind() {
        self.flipperView = nil
        itemSource.onDetached()
    }
    
    public func flipperView(_ flipperView: PAFlipperView, current page: UIView, at index: Int) {
        if(self.primaryItem != page) {
            let oldCell = self.primaryItem
            oldCell?.viewDidDisappear()
            self.currentPage = index
            let newCell = page as! PASegmentView
            newCell.viewWillAppear()
            self.primaryItem = newCell
        }
    }
    
    
    public func onPageChanged(_ flipperView: PAFlipperView, pageIndex: Int) {
        self.pageChangeDelegate?.onPageChanged(flipperView, pageIndex: pageIndex)
    }
    
    
    
}
