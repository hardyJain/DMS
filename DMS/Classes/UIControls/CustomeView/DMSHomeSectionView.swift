//
//  DMSHomeSectionView.swift
//  DMS
//
//  Created by Scorg Technologies on 21/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

class DMSHomeSectionView: UITableViewHeaderFooterView {

    @IBOutlet var lblPatientName: UILabel!
    @IBOutlet var lblUHIDTag: UILabel!
    @IBOutlet var lblUHIDNo: UILabel!
    
    var filterInfo: DMSFilterInfo! {
        didSet {
            self.lblUHIDTag.layer.masksToBounds = true
            self.lblUHIDTag.layer.cornerRadius = 4.0
            self.lblPatientName.text = filterInfo.patientName
            self.lblUHIDNo.text = String(filterInfo!.patientId)
        }
        willSet {
            self.filterInfo = newValue
        }
    }
    
    var PatientName: String? {
        didSet {
            lblPatientName.text = PatientName
        }
    }
    var PatientId: String? {
        didSet {
            lblUHIDNo.text = PatientId
        }
    }

}
