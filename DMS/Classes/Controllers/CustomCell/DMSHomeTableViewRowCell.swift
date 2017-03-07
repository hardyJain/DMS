//
//  DMSHomeTableViewRowCell.swift
//  DMS
//
//  Created by Scorg Technologies on 21/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

class DMSHomeTableViewRowCell: UITableViewCell {

    @IBOutlet var checkBox: UIButton!
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
        self.lblDocType.layer.masksToBounds = true
        self.lblDocType.layer.cornerRadius = 4.0
        
        self.checkBox.setTitle("E", for: .normal)
        self.checkBox.setTitle("G", for: .highlighted)
        self.checkBox.setTitle("G", for: .selected)
        
        self.checkBox.titleLabel?.highlightedTextColor = UIColor.darkGray
        self.checkBox.titleLabel?.tintColor = UIColor.darkGray
        self.checkBox.setTitleColor(UIColor.darkGray, for: .normal)
        self.checkBox.setTitleColor(UIColor.darkGray, for: .selected)
        self.checkBox.setTitleColor(UIColor.darkGray, for: .highlighted)
    }
    
//    var filterInfo: DMSFilterInfo! {
//        didSet {
//            self.lblDocType.text = filterInfo.fileType
//            self.lblDocId.text = filterInfo.fileId
//            self.lblDateFirst.text = filterInfo.dateFrom
//            self.lblDateSecond.text = filterInfo.dateFrom
//        }
//        willSet {
//            self.filterInfo = newValue
//        }
//    }
//    
//    var FileType: String? {
//        didSet {
//            lblDocType.text = FileType
//        }
//    }
//    var FileId: String? {
//        didSet {
//            lblDocId.text = FileId
//        }
//    }
//    var AdmissionDate: String? {
//        didSet {
//            lblDateFirst.text = AdmissionDate
//        }
//    }
//    var DischargeDate: String? {
//        didSet {
//            lblDateSecond.text = DischargeDate
//        }
//    }
}
