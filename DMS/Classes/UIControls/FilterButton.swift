//
//  FilterButton.swift
//  DMS
//
//  Created by Hardik Jain on 17/04/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

class FilterButton: UIButton {
  var shadowLayer: CAShapeLayer!
  override func layoutSubviews() {
    super.layoutSubviews()
    if shadowLayer == nil {
      shadowLayer = CAShapeLayer()
      shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.frame.size.width/2).cgPath
      shadowLayer.fillColor = UIColor(red: 236/255, green: 63/255, blue: 48/255, alpha: 1).cgColor
      shadowLayer.shadowColor = UIColor.darkGray.cgColor
      shadowLayer.shadowPath = shadowLayer.path
      shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
      shadowLayer.shadowOpacity = 0.8
      shadowLayer.shadowRadius = 2
      layer.insertSublayer(shadowLayer, at: 0)
    }
  }
}
