//
//  TableSegmentController.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 07/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

class TableSegmentController: PAController {
    
    
    var pageSource : PAItemControllerSource!
    
    let sectionSource = PASectionDatasource()
    
    func getType() -> Int {
        return 1
    }
    
    func getId() -> String {
        return "1"
    }
    
    func onCreate(_ itemUpdatePublisher: PAItemUpdatePublisher) {
        let arraySource = PAArraySource()
        arraySource.setItems(self.createItems())
        pageSource = arraySource
    }
    
    func onViewDidLoad() {
        NSLog("Controller - Load")
        
        DispatchQueue.global(qos: .background).async {
            self.sectionSource.addSection(item: TableItemController(id: 11111, type: .section), source: self.createDataSource())
            self.sectionSource.addSection(item: TableItemController(id: 11112, type: .section), source: self.createMultiPlexSource())
        }
    }
    
    func onViewWillAppear() {
        NSLog("Controller - WillAppear")
    }
    
    func onViewDidDisapper() {
        NSLog("Controller - Disappear")
    }
    
    func onViewDidUnload() {
        NSLog("Controller - Unload")
    }
    
    func onDestroy() {
        
    }
    
    func isContentEqual(_ rhs: PAController) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        
    }
    
    
    private func createDataSource() -> PAItemControllerSource {
        let source = PAArraySource()
        setArraySourceItemsDelayed(source: source)
        return source
    }
    
    private func createMultiPlexSource() -> PAItemControllerSource {
        let source = PAMultiplexSource()
        source.addSource(source: createDataSource())
        source.addSource(source: createDataSource())
        source.addSource(source: createDataSource())
        source.addSource(source: createDataSource())
        return source
    }
    
    //    private var counter = 0
    
    private func setArraySourceItemsDelayed(source : PAArraySource) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // in half a second...
            source.setItems(self.createItems())
            //            self.setArraySourceItemsDelayed(source: source)
        }
    }
    
    private func createItems() -> [TableItemController] {
        var arr = [TableItemController]()
        for index in 1...100 {
            arr.append(TableItemController(id: index, type: .content))
        }
        //        counter = counter + 5
        return arr
    }
}
