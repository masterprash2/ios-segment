import Foundation
import RxSwift
import UIKit


public class PATableDelegate<T : CaseIterable, Controller : PAItemController> : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let cellProvider : PATableCellProvider<T>
    private let sections : PASectionDatasource<T, Controller>
    private let disposeBag = DisposeBag()
    
    public init(_ cellProvider : PATableCellProvider<T>,_ sections : PASectionDatasource<T, Controller>) {
        self.cellProvider = cellProvider
        self.sections = sections
    }
    
    public func bind(_ tableView : UITableView) {
        self.sections.observeSectionUpdateEvents().map {[weak tableView,weak self] (update) -> Bool in
            if(tableView != nil) {
                self?.performUpdate(tableView!, update)
            }
            return true
        }.subscribe().disposed(by: disposeBag)
    }
    
    private func performUpdate(_ tableView : UITableView, _ update : (Int, PASourceUpdateEventModel) ){
        switch update.1.type {
        case .updateBegins:
            tableView.beginUpdates()
        case .itemsChanges:
            tableView.reloadRows(at: createIndexPathArray(update.0, update.1), with: UITableView.RowAnimation.automatic)
        case .itemsRemoved:
            tableView.deleteRows(at:  createIndexPathArray(update.0, update.1), with: UITableView.RowAnimation.automatic)
        case .itemsAdded:
            tableView.insertRows(at:  createIndexPathArray(update.0, update.1), with: UITableView.RowAnimation.automatic)
        case .itemMoved:
            let oldPath = IndexPath(row: update.1.position, section: update.0)
            let newPath = IndexPath(row: update.1.newPosition, section: update.0)
            tableView.moveRow(at: oldPath, to: newPath)
        case .updateEnds:
            tableView.endUpdates()
        case .sectionMoved:
            tableView.moveSection(update.1.position, toSection: update.1.newPosition)
        }
        
    }
    
    private func createIndexPathArray(_ section : Int,_ update : PASourceUpdateEventModel) -> [IndexPath] {
        var arr = [IndexPath]()
        for i in update.position..<update.position + update.itemCount {
            arr.append(IndexPath.init(row: i, section:section ))
        }
        return arr
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cellProvider.registerCells(tableView: tableView)
        return self.sections.numberOfRowsInSection(section)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemAtIndexPath(indexPath)
        let cell = self.cellProvider.cellForId(tableView: tableView, id: item.type as! T)
        let paTableCell = (cell as! PATableViewCell)
        paTableCell.bind(item: item)
        return cell
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> Controller {
        return self.sections.itemAtIndexPath(indexPath)
    }
    
    func sectionAtIndex(_ index : Int) -> Controller {
        return sections.sectionItemAtIndex(index)
    }
    
}
