//
//  File.swift
//  
//
//  Created by Prashant Rathore on 17/02/20.
//

import Foundation
import RxSwift

open class PASectionDatasource : ViewInteractor {
    
    public func processWhenSafe(_ runnable: () -> Void) {
        runnable()
    }
    
    public func cancelOldProcess(_ runnable: () -> Void) {
        
    }
    
    
    private var sections = [PATableSection]()
    private let disposeBag = DisposeBag()
    private let sectionUpdatePubliser = PublishSubject<(Int,PASourceUpdateEventModel)>()
    
    public init() {
        
    }
    
    func count() -> Int {
        return sections.count
    }
    
    public func addSection(item : PAController, source : PAItemControllerSource) {
        let section = PATableSection(PAItemController(item), source: source)
        source.observeAdapterUpdates().map { [unowned self] (value) -> PASourceUpdateEventModel in
            self.sectionContentUpdate(section, value)
            return value
        }.subscribe().disposed(by: disposeBag)
        section.index = sections.count
        
        source.viewInteractor = self
        
        sections.append(section)
    }
    
    public func numberOfRowsInSection(_ section : Int) -> Int {
        return sections[section].source.itemCount
    }
    
    func sectionContentUpdate(_ section : PATableSection, _ update : PASourceUpdateEventModel) {
        sendSectionEvent((section.index, update))
    }
    
    func notifySectionInserted(_ section : PATableSection) {
        sendSectionEvent((section.index,PASourceUpdateEventModel(type: UpdateEventType.itemsAdded, position: 0, itemCount: section.source.itemCount)))
    }
    
    func sendSectionEvent(_ event : (Int,PASourceUpdateEventModel)) {
        sectionUpdatePubliser.onNext(event)
    }
    
    func observeSectionUpdateEvents() -> Observable<(Int,PASourceUpdateEventModel)> {
        return sectionUpdatePubliser
    }
    
    func sectionItemAtIndex(_ index : Int) -> PAItemController {
        return self.sections[index].item
    }
    
    func itemAtIndexPath(_ indexPath : IndexPath) -> PAItemController {
        return self.sections[indexPath.section].source.getItem(indexPath.row)
    }
    
}


internal class PATableSection {
    
    let item : PAItemController
    let source : PAItemControllerSource
    var index = 0

    init(_ item : PAItemController, source : PAItemControllerSource) {
        self.item = item
        self.source = source
    }
}
