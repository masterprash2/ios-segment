//
//  PAController.swift
//  DeepDiff
//
//  Created by Prashant Rathore on 05/04/20.
//

import Foundation

public protocol PAController {
    
    func getType() -> Int
    func getId() -> Int
    
    func onCreate(_ itemUpdatePublisher : PAItemUpdatePublisher)
    func onViewWillAppear()
    func onViewDidDisapper()
    func onDestroy()
    
    func isContentEqual(_ rhs : PAController) -> Bool
    func hash(into hasher: inout Hasher)
    
}
