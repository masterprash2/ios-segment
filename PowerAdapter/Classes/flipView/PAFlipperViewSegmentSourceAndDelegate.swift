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
        flipperView.setDataSource(self)
        self.itemSource.observeAdapterUpdates().map {[weak flipperView,weak self] (update) -> Bool in
            if(flipperView != nil) {
                //                self?.performUpdate(tableView!, update)
            }
            return true
        }.subscribe().disposed(by: disposeBag)
        self.itemSource.onAttached()
    }
    
    //    private func performUpdate(_ tableView : UITableView, _ update : (Int, PASourceUpdateEventModel) ){
    //        switch update.1.type {
    //        case .updateBegins:
    //            tableView.beginUpdates()
    //        case .itemsChanges:
    //            tableView.reloadRows(at: createIndexPathArray(update.0, update.1), with: UITableView.RowAnimation.automatic)
    //        case .itemsRemoved:
    //            tableView.deleteRows(at:  createIndexPathArray(update.0, update.1), with: UITableView.RowAnimation.automatic)
    //        case .itemsAdded:
    //            tableView.insertRows(at:  createIndexPathArray(update.0, update.1), with: UITableView.RowAnimation.automatic)
    //        case .itemMoved:
    //            let oldPath = IndexPath(row: update.1.position, section: update.0)
    //            let newPath = IndexPath(row: update.1.newPosition, section: update.0)
    //            tableView.moveRow(at: oldPath, to: newPath)
    //        case .updateEnds:
    //            tableView.endUpdates()
    //        case .sectionMoved:
    //            tableView.moveSection(update.1.position, toSection: update.1.newPosition)
    //        case .sectionInserted:
    //            tableView.insertSections(IndexSet.init(arrayLiteral: update.0), with: .automatic)
    //        }
    //
    //    }
    
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
    
    
    
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.sections.numberOfRowsInSection(section)
//    }
    
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count()
//    }
    
    public func flipperView(_ flipperView : PAFlipperView, viewForPageAt index: Int) -> UIView {
        let item = itemAtIndexPath(index)
        let page = self.viewProvider.segmentViewForType(flipperView, item.controller.getType())
        page.bindInternal(parent!, item)
        return page
    }
    
    
    
    public func flipperView(_ flipperView : PAFlipperView, willDisplay page: UIView, forRowAt index: Int) {
        if(self.currentPage == index) {
            let tableCell = page as! PASegmentView
            tableCell.viewWillAppear()
            self.primaryItem = tableCell
        }
    }
    
    public func flipperView(_ flipperView : PAFlipperView, didEndDisplaying page: UIView, forRowAt index: Int) {
        let tableCell = page as! PASegmentView
        tableCell.viewDidDisappear()
        if(self.currentPage == index) {
            self.currentPage = -1
            self.primaryItem = nil
        }
        tableCell.unBind()
    }
    
    public func flipperView(_ flipperView : PAFlipperView, destroy page: UIView, forRowAt index: Int) {
        let tableCell = page as! PASegmentView
        tableCell.unBindInternal()
    }
    
    public func itemAtIndexPath(_ index: Int) -> PAItemController {
        return self.itemSource.getItem(index)
    }
    
    
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return cellProvider.heightForCell(tableView, itemAtIndexPath(indexPath).controller)
//    }
    
    func unBind() {
//        self.flipperView?.dataSource = nil
//        self.flipperView?.delegate = nil
        self.flipperView = nil
        itemSource.onDetached()
    }
    
    
//    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        updateCurrentPage()
//    }
//
//
//    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
//        updateCurrentPage()
//    }
//
//    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        updateCurrentPage()
//    }
//
//
//    private func updateCurrentPage() {
//        if(self.isPagingEnabled) {
//            if let tableView = self.tableView {
//                let center = CGPoint(x: tableView.contentOffset.x + (tableView.frame.width / 2), y: tableView.contentOffset.y + (tableView.frame.height / 2))
//                if let ip = tableView.indexPathForRow(at: center) {
//                    if(self.currentPage != ip) {
//                        setCurrentPage(tableView, ip)
//                    }
//                }
//            }
//        }
//    }
    
    public func onPageChanged(_ flipperView: PAFlipperView, pageIndex: Int, page : UIView) {
        let oldCell = self.primaryItem
        oldCell?.viewDidDisappear()
        self.currentPage = pageIndex
        let newCell = page as! PASegmentView
        newCell.viewWillAppear()
        self.pageChangeDelegate?.onPageChanged(flipperView, pageIndex: pageIndex, page: page)
        self.primaryItem = newCell
    }
    
    
    
}
