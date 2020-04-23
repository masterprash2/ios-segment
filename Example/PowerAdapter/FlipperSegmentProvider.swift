//
//  FlipperSegmentProvider.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 20/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

class FlipperSegmentProvider: PASegmentViewProvider {
    
    func segmentViewForType(_ flipperView: PAFlipperView, _ type: Int) -> PASegmentView {
        let frame = CGRect.init(x: 0, y: 0, width: flipperView.frame.size.width, height: flipperView.frame.size.height)
        
        let view = ContentView(frame: frame)
        view.backgroundColor = UIColor.blue
        return view
    }
    
    
}
