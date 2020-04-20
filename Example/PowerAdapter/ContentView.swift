//
//  ContentView.swift
//  PowerAdapter_Example
//
//  Created by Prashant Rathore on 20/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import PowerAdapter

class ContentView : PASegmentView {
    
    
    override func bind() {
        let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        let label = UILabel(frame: frame)
        label.text = "Userkaf was a pharaoh of ancient Egypt and the founder of the Fifth Dynasty. Before ascending the throne, he may have been a high priest of Ra. He reigned for seven to eight years in the early 25th century BC, during the Old Kingdom period. He built a sun temple, known as the Nekhenre, that mainly functioned as a mortuary temple associated with the setting sun. Rites performed in the temple were primarily concerned with Ra's creator function and his role as father of the king. Userkaf built a pyramid in Saqqara, close to that of Djoser, with a mortuary temple that was much smaller than those built during the Fourth Dynasty. Its mortuary complex was lavishly decorated with fine painted reliefs. Little is known of Userkaf's activities beyond the construction of his pyramid and sun temple. There may have been a military expedition to Canaan or the Eastern Desert, and there probably were trade contacts with the Aegean civilizations."
        label.font = UIFont.boldSystemFont(ofSize: 33)
        label.lineBreakMode = .byCharWrapping
        label.backgroundColor = UIColor.gray
        label.numberOfLines = 0
        self.addSubview(label)
    }
    
}
