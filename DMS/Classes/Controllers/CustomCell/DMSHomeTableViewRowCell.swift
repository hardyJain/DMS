//
//  DMSHomeTableViewRowCell.swift
//  DMS
//
//  Created by Scorg Technologies on 21/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

class DMSHomeTableViewRowCell: UITableViewCell {

  //IBOutlet
  @IBOutlet var checkBox: UIButton!
  @IBOutlet var bottomLine: UIView!
  @IBOutlet var btnMore: UIButton!
  @IBOutlet var lblDateSecond: UILabel!
  @IBOutlet var lblDateTypeSecond: UILabel!
  @IBOutlet var lblDateFirst: UILabel!
  @IBOutlet var lblDateTypeFirst: UILabel!
  @IBOutlet var lblDocId: UILabel!
  @IBOutlet var lblDocType: UILabel!
  //Variables
  var section: Int = -1
  var index: Int = -1
  var pdfArchived: PdfFileArchivedDetails?
  var selectedRecords: ((PdfFileArchivedDetails, UIButton, Int, Int) -> Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    self.initHomeCell()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
    
  func initHomeCell() {
    self.btnMore.isHidden = true
    self.bottomLine.isHidden = true
    self.lblDocType.layer.masksToBounds = true
    self.lblDocType.layer.cornerRadius = 4.0
    self.checkBox.setTitle("V", for: .normal)
    self.checkBox.setTitle("P", for: .highlighted)
    self.checkBox.setTitle("P", for: .selected)
    self.checkBox.titleLabel?.highlightedTextColor = UIColor.darkGray
    self.checkBox.titleLabel?.tintColor = UIColor.darkGray
    self.checkBox.setTitleColor(UIColor.darkGray, for: .normal)
    self.checkBox.setTitleColor(UIColor.darkGray, for: .selected)
    self.checkBox.setTitleColor(UIColor.darkGray, for: .highlighted)
  }
    
  @IBAction func checkBoxBtnTapped(_ sender: UIButton) {
    self.selectedRecords?(self.pdfArchived!, sender, self.section, self.index)
  }
}
