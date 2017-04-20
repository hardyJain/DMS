//
//  DMSFilterTableViewCell.swift
//  DMS
//
//  Created by Scorg Technologies on 22/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class DMSFilterTableViewCell: UITableViewCell {

  @IBOutlet var txtContent: SkyFloatingLabelTextFieldWithIcon!
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
    self.txtContent?.iconFont = UIFont(name: "DMSFont", size: 20)
  }
}
