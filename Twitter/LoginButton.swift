//
//  loginButton.swift
//  Twitter
//
//  Created by admin on 7/30/16.
//  Copyright © 2016 nguyen thanh thuc. All rights reserved.
//

import UIKit

@IBDesignable
class LoginButton: UIButton {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = self.bounds.size.height/2
        self.layer.masksToBounds = true
        
    }
    

}
