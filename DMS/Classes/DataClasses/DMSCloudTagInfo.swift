//
//  DMSCloudTagInfo.swift
//  DMS
//
//  Created by Hardik Jain on 14/04/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

class DMSCloudTagInfo: NSObject {
  
  var tagDocType: [String] = [String]()
  
  override init() {
    super.init()
  }
  
  //Method for creating tag on homeview.
  func createCloudTagData() {
    //Get value form filter info class and append tag identifier to value and assign to array tag view for create tag on homeviewcontroller.
    Globals.sharedInstance.arrayTagViewData.removeAll()
    
    for tagName in tagDocType {
      Globals.sharedInstance.arrayTagViewData.append("DT: \(tagName)")
    }
    
    if Globals.sharedInstance.filterInfo.patientId != "" {
      Globals.sharedInstance.arrayTagViewData.append("UHID: \(Globals.sharedInstance.filterInfo.patientId)")
    }
    if Globals.sharedInstance.filterInfo.dateType != "" {
      Globals.sharedInstance.arrayTagViewData.append("DateT: \(Globals.sharedInstance.filterInfo.dateType)")
    }
    if Globals.sharedInstance.filterInfo.fileType != "" {
      Globals.sharedInstance.arrayTagViewData.append("FT: \(Globals.sharedInstance.filterInfo.fileType)")
    }
    if Globals.sharedInstance.filterInfo.dateFrom != "" {
      Globals.sharedInstance.arrayTagViewData.append("From: \(Globals.sharedInstance.filterInfo.dateFrom)")
    }
    if Globals.sharedInstance.filterInfo.dateTo != "" {
      Globals.sharedInstance.arrayTagViewData.append("To: \(Globals.sharedInstance.filterInfo.dateTo)")
    }
    if Globals.sharedInstance.filterInfo.patientName != "" {
      Globals.sharedInstance.arrayTagViewData.append("Name: \(Globals.sharedInstance.filterInfo.patientName)")
    }
    if Globals.sharedInstance.filterInfo.annotationText != "" {
      Globals.sharedInstance.arrayTagViewData.append("Annot: \(Globals.sharedInstance.filterInfo.annotationText)")
    }
    if Globals.sharedInstance.filterInfo.referenceId != "" {
      Globals.sharedInstance.arrayTagViewData.append("Ref_id: \(Globals.sharedInstance.filterInfo.referenceId)")
    }
    
    //assigning value to dictionary for create relation between tag and tagdata for checking which tag is removed and again fire the w/s request.
    Globals.sharedInstance.dictTagView[Globals.sharedInstance.filterInfo.filterPatientIdKey] = Globals.sharedInstance.filterInfo.patientId as AnyObject?
    
    Globals.sharedInstance.dictTagView[Globals.sharedInstance.filterInfo.filterDateTypeKey] = Globals.sharedInstance.filterInfo.dateType as AnyObject?
    
    Globals.sharedInstance.dictTagView[Globals.sharedInstance.filterInfo.filterFileTypeKey] = Globals.sharedInstance.filterInfo.fileType as AnyObject?
    
    Globals.sharedInstance.dictTagView[Globals.sharedInstance.filterInfo.filterDateFromKey] = Globals.sharedInstance.filterInfo.dateFrom as AnyObject?
    
    Globals.sharedInstance.dictTagView[Globals.sharedInstance.filterInfo.filterDateToKey] = Globals.sharedInstance.filterInfo.dateTo as AnyObject?
    
    Globals.sharedInstance.dictTagView[Globals.sharedInstance.filterInfo.filterPatientNameKey] = Globals.sharedInstance.filterInfo.patientName as AnyObject?
    
    Globals.sharedInstance.dictTagView[Globals.sharedInstance.filterInfo.filterAnnotationTextKey] = Globals.sharedInstance.filterInfo.annotationText as AnyObject?
    
    Globals.sharedInstance.dictTagView[Globals.sharedInstance.filterInfo.filterReferenceIdKey] = Globals.sharedInstance.filterInfo.referenceId as AnyObject?
    
    Globals.sharedInstance.dictTagView[Globals.sharedInstance.filterInfo.filterDocTypeIdKey] = Globals.sharedInstance.filterInfo.docTypeId as AnyObject?
  }
}
