//
//  PaginationViewCell.swift
//  DMS
//
//  Created by Swapnil Dhotre on 14/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

class DMSPaginationViewCell: UITableViewCell {
  @IBOutlet weak var pageView: UIView!
  @IBOutlet weak var labelPageNumber: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    //        self.pageView.layer.cornerRadius = 2
    self.pageView.layer.shadowColor = UIColor.black.cgColor
    self.pageView.layer.shadowOffset = CGSize(width: 0, height: 0)
    self.pageView.layer.shadowOpacity = 1
    self.pageView.layer.shadowRadius = 4
    
    self.labelPageNumber.text = "0"
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
