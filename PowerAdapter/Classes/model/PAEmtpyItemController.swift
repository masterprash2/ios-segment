//
//  File.swift
//  
//
//  Created by Prashant Rathore on 17/02/20.
//

import Foundation

class PAEmtpyItemController: PAItemController {
    
    static func == (lhs: PAEmtpyItemController, rhs: PAEmtpyItemController) -> Bool {
        return true
    }
    
    
    typealias DiffId = Int32
    
    var id: Int32 = 0
    var diffId: Int32
    var type: PAEmptyEnum = .empty
    
    
    init() {
        diffId = id
    }
    
    func onCreate(_ itemUpdatePublisher: PAItemUpdatePublisher) {
        
    }
    
    func onAttach(source: Any) {
        
    }
    
    func onDetach(source: Any) {
        
    }
    
    func onDestroy() {
        
    }
        
    static func compareContent(_ a: PAEmtpyItemController, _ b: PAEmtpyItemController) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        
    }

    
}
