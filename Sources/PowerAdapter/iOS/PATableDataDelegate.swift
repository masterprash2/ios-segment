import Foundation
import RxSwift
import UIKit


class PATableDataDelegate<T : CaseIterable, Controller : PAItemController> : NSObject, UITableViewDataSource, UITableViewDelegate {
    
    private let cellProvider : PATableCellProvider<T>
    private let sections : PASectionDatasource<T, Controller>
    private let disposeBag = DisposeBag()
    
    init(cellProvider : PATableCellProvider<T>, sections : PASectionDatasource<T, Controller>) {
        self.cellProvider = cellProvider
        self.sections = sections
    }
    
    func bind(_ tableView : UITableView) {
        self.sections.observeSectionUpdateEvents().map {[weak tableView,weak self] (update) -> Bool in
            if(tableView != nil) {
                self?.performUpdate(tableView!, update)
            }
            return true
        }.subscribe().disposed(by: disposeBag)
    }
    
    private func performUpdate(_ tableView : UITableView, _ update : (Int, PASourceUpdateEventModel) ){
        tableView.reloadRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cellProvider.registerCells(tableView: tableView)
        return self.sections.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemAtIndexPath(indexPath)
        let cell = self.cellProvider.cellForId(tableView: tableView, id: item.type as! T)
        let paTableCell = (cell as! PATableViewCell)
        paTableCell.bind(item: item)
        return cell
    }
    
    func itemAtIndexPath(_ indexPath: IndexPath) -> Controller {
        return self.sections.itemAtIndexPath(indexPath)
    }
    
    func sectionAtInde(_ index : Int) -> Controller {
        return sections.sectionItemAtIndex(index)
    }
    
}
