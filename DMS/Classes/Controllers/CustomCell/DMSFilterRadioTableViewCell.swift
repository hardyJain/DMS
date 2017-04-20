//
//  DMSFilterRadioTableViewCell.swift
//  DMS
//
//  Created by Scorg Technologies on 23/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class DMSFilterRadioTableViewCell: UITableViewCell {

  @IBOutlet var txtDocType: SkyFloatingLabelTextFieldWithIcon!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.initRadioButtonView()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func initRadioButtonView() {
    self.txtDocType?.iconFont = UIFont(name: "DMSFont", size: 20)
  }
}
