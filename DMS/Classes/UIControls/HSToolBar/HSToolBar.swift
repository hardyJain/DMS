//
//  HSToolBar.swift
//  DMS
//
//  Created by Scorg Technologies on 21/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit


@objc protocol HSToolbarDelegate {
  func onToolbarDone(sender:UIButton)
  @objc optional func onMovePrevious(sender:UIButton)
  @objc optional func onMoveNext(sender:UIButton)
}

class HSToolBar: UIToolbar {
  private let lblTitle: UILabel = UILabel()
  let btnPrevious:UIButton = UIButton(frame: CGRect(x: 15, y: 6, width: 53, height: 33))
  let btnNext:UIButton = UIButton(frame: CGRect(x: 15, y: 6, width: 53, height: 33))
  let btnDone:UIButton = UIButton(frame: CGRect(x: 15, y: 6, width: 53, height: 33))
  var toolBarDelegate: HSToolbarDelegate?
  var isDoneOnly:Bool = false
  var title: String {
    get {
      return self.lblTitle.text!
    }
    set {
      self.lblTitle.text = newValue
      self.lblTitle.sizeToFit()
    }
  }
  
  init(doneOnly:Bool) {
    super.init(frame: CGRect.zero)
    self.isDoneOnly = doneOnly
    self.initToolBarView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.initToolBarView()
  }
  
  func initToolBarView() {
    self.barStyle = UIBarStyle.default
    self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50)
    
    let FontSize:CGFloat = 22
    self.barTintColor = UIColor(red: 89/255, green: 177/255, blue: 213/255, alpha: 1)
    // Done Button
    // self.btnDone = UIButton(frame: CGRectMake(15, 6, 53, 33))
    self.btnDone.setTitle("J", for: UIControlState.normal)
    self.btnDone.setTitleColor(UIColor.white, for: UIControlState.normal)
    self.btnDone.setTitleColor(UIColor.lightGray, for: UIControlState.disabled)
    self.btnDone.titleLabel?.font = UIFont(name: "DMSFont", size: FontSize + 2)
    self.btnDone.addTarget(self.toolBarDelegate, action: #selector(HSToolbarDelegate.onToolbarDone(sender:)), for: UIControlEvents.touchUpInside)
    let barDoneItem:UIBarButtonItem = UIBarButtonItem(customView: self.btnDone)
    
    // Title Label
    self.lblTitle.textAlignment = NSTextAlignment.center
    self.lblTitle.textColor = UIColor.gray
    let barTitleItem: UIBarButtonItem = UIBarButtonItem(customView: self.lblTitle)
    
    // Flexible space
    let flexSpaceItem1:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    let flexSpaceItem2:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
    if self.isDoneOnly {
      self.items = [flexSpaceItem1, barTitleItem, flexSpaceItem2, barDoneItem]
    }
    else {
      // Previous Button
      // self.btnPrevious = UIButton(frame: CGRectMake(15, 6, 53, 33))
      self.btnPrevious.setTitle("T", for: UIControlState.normal)
      self.btnPrevious.setTitleColor(UIColor.white, for: UIControlState.normal)
      self.btnPrevious.setTitleColor(UIColor.lightGray, for: UIControlState.disabled)
      self.btnPrevious.titleLabel?.font = UIFont(name: "DMSFont", size: FontSize)
      self.btnPrevious.addTarget(self.toolBarDelegate, action: #selector(HSToolbarDelegate.onMovePrevious(sender:)), for: UIControlEvents.touchUpInside)
      let barPrevItem:UIBarButtonItem = UIBarButtonItem(customView: self.btnPrevious)
      // Next Button
      // self.btnNext = UIButton(frame: CGRectMake(15, 6, 53, 33))
      self.btnNext.setTitle("U", for: UIControlState.normal)
      self.btnNext.setTitleColor(UIColor.white, for: UIControlState.normal)
      self.btnNext.setTitleColor(UIColor.lightGray, for: UIControlState.disabled)
      self.btnNext.titleLabel?.font = UIFont(name: "DMSFont", size: FontSize)
      self.btnNext.addTarget(self.toolBarDelegate, action: #selector(HSToolbarDelegate.onMoveNext(sender:)), for: UIControlEvents.touchUpInside)
      let barNextItem:UIBarButtonItem = UIBarButtonItem(customView: self.btnNext)
      self.items = [barPrevItem, barNextItem, flexSpaceItem1, barTitleItem, flexSpaceItem2, barDoneItem]
    }
  }
}
