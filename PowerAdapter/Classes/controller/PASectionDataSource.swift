//
//  File.swift
//  
//
//  Created by Prashant Rathore on 17/02/20.
//

import Foundation
import RxSwift

open class PASectionDatasource<T : CaseIterable, Controller: PAItemController> {
    
    private var sections = [PATableSection<T, Controller>]()
    private let disposeBag = DisposeBag()
    private let sectionUpdatePubliser = PublishSubject<(Int,PASourceUpdateEventModel)>()
    
    public init() {
        
    }
    
    func count() -> Int {
        return sections.count
    }
    
    public func addSection(item : Controller, source : PAItemControllerSource<T, Controller>) {
        let section = PATableSection(item, source: source)
        source.observeAdapterUpdates().map { [unowned self] (value) -> PASourceUpdateEventModel in
            self.sectionContentUpdate(section, value)
            return value
        }.subscribe().disposed(by: disposeBag)
        section.index = sections.count
        sections.append(section)
    }
    
    func sectionContentUpdate(_ section : PATableSection<T, Controller>, _ update : PASourceUpdateEventModel) {
        sendSectionEvent((section.index, update))
    }
    
    func notifySectionInserted(_ section : PATableSection<T, Controller>) {
        sendSectionEvent((section.index,PASourceUpdateEventModel(type: UpdateEventType.itemsAdded, position: 0, itemCount: section.source.itemCount)))
    }
    
    func sendSectionEvent(_ event : (Int,PASourceUpdateEventModel)) {
        sectionUpdatePubliser.onNext(event)
    }
    
    func observeSectionUpdateEvents() -> Observable<(Int,PASourceUpdateEventModel)> {
        return sectionUpdatePubliser
    }
    
    func sectionItemAtIndex(_ index : Int) -> Controller {
        return self.sections[index].item
    }
    
    func itemAtIndexPath(_ indexPath : IndexPath) -> Controller {
        return self.sections[indexPath.section].source.getItem(indexPath.row)
    }
    
}


internal class PATableSection<T : CaseIterable, Controller: PAItemController> {
    
    let item : Controller
    let source : PAItemControllerSource<T, Controller>
    var index = 0

    init(_ item : Controller, source : PAItemControllerSource<T, Controller>) {
        self.item = item
        self.source = source
    }
}
