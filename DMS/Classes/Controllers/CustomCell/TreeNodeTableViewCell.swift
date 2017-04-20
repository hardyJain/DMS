//
//  TreeNodeTableViewCell.swift
//  TreeView
//
//  Created by Swapnil Dhotre on 10/04/17.
//  Copyright © 2017 Swapnil Dhotre. All rights reserved.
//

import UIKit

class TreeNodeTableViewCell: UITableViewCell {
  var btnArrowTapped: ((IndexPath) -> Void)?
  var btnCheckUncheckTapped: ((IndexPath) -> Void)?
  var indexPath: IndexPath?
  
  @IBOutlet weak var btnArrow: UIButton!
  @IBOutlet weak var btnCheckUncheck: UIButton!
  @IBOutlet weak var labelTitle: UILabel!
  @IBOutlet weak var indentationSpace: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  @IBAction func btnArrowTapped(_ sender: UIButton) {
    
    self.btnArrowTapped!(self.indexPath!)
  }
  
  @IBAction func btnCheckUncheckTapped(_ sender: UIButton) {
    
    self.btnCheckUncheckTapped!(self.indexPath!)
  }
}
