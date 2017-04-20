//
//  Globals.swift
//  DMS
//
//  Created by Scorg Technologies on 07/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import Foundation
import UIKit

class Globals {
  var isPerformedFilter: Bool = false
  var patientList = Array<DMSFilterInfo>()
  var patientFileData = [[[String: AnyObject]]]()
  var arrayTagViewData = [String]()
  var dictTagView = Dictionary<String,AnyObject>()
  var filterInfo: DMSFilterInfo = DMSFilterInfo()
  var archivedData: [PdfFileArchivedDetails] = []
  var isPdfScrollable: Bool = false
  static let sharedInstance = Globals()
    
  init() {
    self.initFromUserLocal()
  }
    
  private func initFromUserLocal() {
    //Implement for user local information
  }
    
  func getRequestHeaderParams() -> [String: String] {
    let headers = ["Device-Id": Constants.deviceId, "OS": "iOS", "OS-Version": Constants.OSVersion]
        return headers
    }
}
