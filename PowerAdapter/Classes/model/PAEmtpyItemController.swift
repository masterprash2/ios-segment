//
//  File.swift
//  
//
//  Created by Prashant Rathore on 17/02/20.
//

import Foundation

class PAEmtpyItemController: PAController {
    
    
    func getType() -> Int {
        1
    }
    
    func getId() -> String {
        return "1"
    }
    
    func onCreate(_ itemUpdatePublisher: PAItemUpdatePublisher) {
           
    }
    
    func onViewWillAppear() {
        
    }
    
    func onViewDidDisapper() {
        
    }
    
    func onDestroy() {
        
    }
    
    
    func isContentEqual(_ rhs: PAController) -> Bool {
        return true
    }
    
    
   
    func hash(into hasher: inout Hasher) {
        
    }
    
}
