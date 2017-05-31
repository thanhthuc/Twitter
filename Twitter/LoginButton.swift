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

    override func awakeFromNib() {
        self.layer.cornerRadius = self.bounds.size.height/3
        self.layer.masksToBounds = true
    }
}
