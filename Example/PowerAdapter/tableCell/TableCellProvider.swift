//
//  TableCellProvider.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 18/02/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

class TableCellProvider : PACollectionViewCellProvider {
    
    
    override func registerCells(_ collectionView: UICollectionView) {
        TableItemType.allCases.forEach { (type) in
            let name = cellNameForType(type)
            collectionView.register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
        }
    }
    
    override func cellForController(_ collectionView: UICollectionView, _ controller: PAController, _ indexPath: IndexPath) -> UICollectionViewCell {

        let cell = super.cellForController(collectionView, controller, indexPath) as! PACollectionViewCell
        cell.bounds.size = collectionView.frame.size
        cell.rootView!.bounds.size = collectionView.frame.size
        return cell;
    }
    
    
    override func cellNameForController(_ controller: PAController) -> String {
        return cellNameForType(TableItemType(rawValue: controller.getType())!)
    }
    
    func cellNameForType(_ type: TableItemType) -> String {
        switch type {
        case .content:
            return "DataListCell"
        case .section:
            return "DataListCell"
        }
    }
    
//    override func heightForCell(_ tableView: UITableView, _ controller: PAController) -> CGFloat {
//        return tableView.frame.size.height
//    }
    
    
}
