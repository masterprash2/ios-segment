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
    
    private var tableDelegate : PATableDelegate<TableItemType,TableItemController>!
    
    required init(coder: NSCoder) {
        let cellProvider = TableCellProvider()
        let sectionSource = PASectionDatasource<TableItemType,TableItemController>()
        tableDelegate = PATableDelegate.init(cellProvider, sectionSource)
        super.init(coder: coder)!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = tableDelegate
        tableView.dataSource = tableDelegate
        tableDelegate.bind(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

