//
//  DMSHomeTableViewRowCell.swift
//  DMS
//
//  Created by Scorg Technologies on 21/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import QuartzCore

class DMSHomeTableViewRowCell: UITableViewCell {

    @IBOutlet var btnCheckBox: UIButton!
    @IBOutlet var bottomLine: UIView!
    @IBOutlet var btnMore: UIButton!
    @IBOutlet var lblDateSecond: UILabel!
    @IBOutlet var lblDateTypeSecond: UILabel!
    @IBOutlet var lblDateFirst: UILabel!
    @IBOutlet var lblDateTypeFirst: UILabel!
    @IBOutlet var lblDocId: UILabel!
    @IBOutlet var lblDocType: UILabel!
    
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
        self.lblDocType.layer.cornerRadius = 15.0
        self.btnCheckBox.layer.borderWidth = 1
        self.btnCheckBox.layer.cornerRadius = 2
        self.btnCheckBox.layer.borderColor = UIColor.darkGray.cgColor
    }
}
