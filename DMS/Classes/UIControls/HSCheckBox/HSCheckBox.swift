//
//  HSCheckBox.swift
//  DMS
//
//  Created by Scorg Technologies on 03/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

@objc protocol HSCheckBoxDelegate {
    @objc optional func checkboxDidSelected(sender:UIButton)
}
class HSCheckBox: UIButton {
    
    init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCheckBoxBtn() {
        
    }
}
