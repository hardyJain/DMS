//
//  OptionsInfoTableViewCell.swift
//  DMS
//
//  Created by Swapnil Dhotre on 14/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

class DMSOptionsInfoTableViewCell: UITableViewCell {
  @IBOutlet weak var labelIcon: UILabel!
  @IBOutlet weak var optionKeyLabel: UILabel!
  @IBOutlet weak var optionValueLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }

}
