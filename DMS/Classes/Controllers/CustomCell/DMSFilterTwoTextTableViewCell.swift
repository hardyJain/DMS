//
//  DMSFilterTwoTextTableViewCell.swift
//  DMS
//
//  Created by Scorg Technologies on 23/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class DMSFilterTwoTextTableViewCell: UITableViewCell {

  @IBOutlet var txtContentFirst: SkyFloatingLabelTextFieldWithIcon!
  @IBOutlet var txtContentSecond: SkyFloatingLabelTextFieldWithIcon!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.setupFilterCell()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  func setupFilterCell() {
    self.txtContentFirst?.iconFont = UIFont(name: "DMSFont", size: 20)
    self.txtContentSecond?.iconFont = UIFont(name: "DMSFont", size: 20)
  }
}
