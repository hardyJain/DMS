//
//  DMSFilterExpandTableViewCell.swift
//  DMS
//
//  Created by Scorg Technologies on 06/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

class DMSFilterExpandTableViewCell: UITableViewCell {

  @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
  @IBOutlet var checkBoxbtn: UIButton!
  @IBOutlet var lblTitle: UILabel!
  var treeNode: TreeViewNode!
  @IBOutlet weak var btnExpand: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.initExpandCell()
  }
  
  override func draw(_ rect: CGRect) {
    var cellFrame: CGRect = self.lblTitle.frame
    var buttonFrame: CGRect = self.btnExpand.frame
    let indentation: Int = self.treeNode.nodeLevel! * 25
    cellFrame.origin.x = buttonFrame.size.width + CGFloat(indentation) + 5
    buttonFrame.origin.x = 2 + CGFloat(indentation)
    self.lblTitle.frame = cellFrame
    self.btnExpand.frame = buttonFrame
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  func initExpandCell() {
    self.btnExpand.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    self.checkBoxbtn.setTitle("V", for: .normal)
    self.checkBoxbtn.setTitle("P", for: .highlighted)
    self.checkBoxbtn.setTitle("P", for: .selected)
    self.checkBoxbtn.titleLabel?.highlightedTextColor = UIColor.darkGray
    self.checkBoxbtn.titleLabel?.tintColor = UIColor.darkGray
    self.checkBoxbtn.setTitleColor(UIColor.darkGray, for: .normal)
    self.checkBoxbtn.setTitleColor(UIColor.darkGray, for: .selected)
    self.checkBoxbtn.setTitleColor(UIColor.darkGray, for: .highlighted)
  }
  
  @IBAction func onExpandBtn(_ sender: UIButton) {
    if (self.treeNode != nil) {
      if self.treeNode.nodeChildren != nil {
        if self.treeNode.isExpanded == Constants.FilterExpand.TRUE {
          self.treeNode.isExpanded = Constants.FilterExpand.FALSE
        } else {
          self.treeNode.isExpanded = Constants.FilterExpand.TRUE
        }
      } else {
        self.treeNode.isExpanded = Constants.FilterExpand.FALSE
      }
      self.isSelected = false
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TreeNodeButtonClicked"), object: self)
      //print("button clicked")
    }
  }
}
