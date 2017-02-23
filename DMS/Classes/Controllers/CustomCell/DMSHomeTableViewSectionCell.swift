//
//  DMSHomeTableViewSectionCell.swift
//  DMS
//
//  Created by Scorg Technologies on 21/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

class DMSHomeTableViewSectionCell: UITableViewCell {

    @IBOutlet var lblPatientName: UILabel!
    @IBOutlet var lblUHIDNo: UILabel!
    @IBOutlet var lblUHIDTag: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
