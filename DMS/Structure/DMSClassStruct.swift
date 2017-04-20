//
//  DMSClassStruct.swift
//  DMS
//
//  Created by Hardik Jain on 17/04/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

//Home View Controller Details Struct.
struct PdfFileArchivedDetails {
  //Patient Info
  var patientId: String
  var patientName: String
  var uhid: String
  var location: String
  
  //File Info
  var fileType: String
  var referenceId: String
  var doctorName: String
  var admissionDate: String
  var dischargeDate: String
}

//PDF Compare Drawer View Controller Cell Struct.
struct CellRecords {
  
  var icon: String
  var key: String
  var value: String
  var encircled: Bool
}

//PDF Compare Drawer View Controller Section Struct.
struct Sections {
  
  var header: String
  var badgeString: String
  var objects: [CellRecords]
}

