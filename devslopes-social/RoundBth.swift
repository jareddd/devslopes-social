//
//  RoundBth.swift
//  devslopes-social
//
//  Created by jareddd on 5/7/17.
//  Copyright © 2017 jetfuel. All rights reserved.
//

import UIKit

class RoundBth: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //use a contstant
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        imageView?.contentMode = .scaleAspectFit
        //we want perfectly round butt
        //size of the frame has not yet been calculated need a different place to
    }
    
    override func layoutSubviews() {
        //frame size has been calculated
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        
    }
    
    

}
