//
//  ViewController.swift
//  PowerAdapter
//
//  Created by masterprash2 on 02/18/2020.
//  Copyright (c) 2020 masterprash2. All rights reserved.
//

import UIKit
import PowerAdapter

class ViewController: UIViewController {
    
    @IBOutlet var tableView : UITableView!
    private let sectionSource = PASectionDatasource<TableItemType,TableItemController>()
    
    private var tableDelegate : PATableDelegate<TableItemType,TableItemController>!
    
    required init(coder: NSCoder) {
        let cellProvider = TableCellProvider()
        tableDelegate = PATableDelegate(cellProvider, sectionSource)
        super.init(coder: coder)!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
        tableDelegate.bind(self.tableView)
        self.sectionSource.addSection(item: TableItemController(id: 11111, type: .section), source: createDataSource())
        self.sectionSource.addSection(item: TableItemController(id: 11112, type: .section), source: createMultiPlexSource())
    }
    
    private func createDataSource() -> PAItemControllerSource<TableItemType, TableItemController> {
        let source = PAArraySource<TableItemType, TableItemController>()
        setArraySourceItemsDelayed(source: source)
        return source
    }
    
    private func createMultiPlexSource() -> PAItemControllerSource<TableItemType, TableItemController> {
        let source = PAMultiplexSource<TableItemType, TableItemController>()
        source.addSource(adapter: createDataSource())
        source.addSource(adapter: createDataSource())
        source.addSource(adapter: createDataSource())
        source.addSource(adapter: createDataSource())
        return source
    }
    
//    private var counter = 0
    
    private func setArraySourceItemsDelayed(source : PAArraySource<TableItemType, TableItemController>) {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

