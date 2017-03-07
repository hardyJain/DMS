//
//  DMSFilterInfo.swift
//  DMS
//
//  Created by Scorg Technologies on 01/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

private let filterPatientIdKey = "patientId"
private let filterPatientNameKey = "patientName"
private let filterFileTypeKey = "fileType"
private let filterReferenceIdKey = "referenceId"
private let filterDateTypeKey = "dateType"
private let filterDateFromKey = "fromDate"
private let filterDateToKey = "toDate"
private let filterAnnotationTextKey = "annotationText"
private let filterDocTypeIdKey = "DocTypeId"
//Response Key
private let filterFileDataKey = "patientFileData"
private let filterPatientAdmDate = "admissionDate"
private let filterPatientDisDate = "dischargeDate"

class DMSFilterInfo: NSObject {
    //Request Keys
    lazy var grantType = ""
    lazy var patientId = ""
    lazy var patientName = ""
    lazy var fileType = ""
    lazy var fileId = ""
    lazy var referenceId = ""
    lazy var dateType = ""
    lazy var dateFrom = ""
    lazy var dateTo = ""
    lazy var annotationText = ""
    lazy var docTypeId = [AnyObject]()
    
    override init() {
        super.init()
    }
    
    init(_ result: JSON) {
        super.init()
        
//        let dataDict = JSON(result)
        
        if let val = result[filterPatientIdKey].int {
            patientId = String(val)
        }
        if let val = result[filterPatientNameKey].string {
            patientName = val
        }
        if let fileData = result[filterFileDataKey].array {
            for val in fileData {
                if let amdDate = val[filterPatientAdmDate].string {
                    let date = Utility.convertDateStringToDate(date: amdDate)
                    dateFrom = Utility.convertDateToDateString(date: date!)
                }
                if let disDate = val[filterPatientDisDate].string {
                    dateTo = disDate
                }
                if let fType = val[filterFileTypeKey].string {
                    fileType = fType
                }
                if let refId = val[filterReferenceIdKey].string {
                    referenceId = refId
                }
            }
        }
        
        if let val = result[filterFileTypeKey].string {
            fileType = val
        }
        if let val = result[filterReferenceIdKey].string {
            referenceId = val
        }
        if let val = result[filterDateTypeKey].string {
            dateType = val
        }
        if let val = result[filterDateFromKey].string {
            dateFrom = val
        }
        if let val = result[filterDateToKey].string {
            dateTo = val
        }
        if let val = result[filterAnnotationTextKey].string {
            annotationText = val
        }
        if let val = result[filterDocTypeIdKey].arrayObject {
            docTypeId = [val as AnyObject]
        }
    }
    
    func getDataDictionaryForWS() -> Dictionary<String, AnyObject> {
        var filterParams = Dictionary<String,AnyObject>()
        filterParams[filterPatientIdKey] = patientId as AnyObject?
        filterParams[filterPatientNameKey] = patientName as AnyObject?
        filterParams[filterFileTypeKey] = fileType as AnyObject?
        filterParams[filterReferenceIdKey] = referenceId as AnyObject?
        filterParams[filterDateTypeKey] = dateType as AnyObject?
        filterParams[filterDateFromKey] = dateFrom as AnyObject?
        filterParams[filterDateToKey] = dateTo as AnyObject?
        filterParams[filterAnnotationTextKey] = annotationText as AnyObject?
        filterParams[filterDocTypeIdKey] = docTypeId as AnyObject?
        return filterParams
    }
}

class DMSFilterList : NSObject {
    
    lazy var patientFilterList : [DMSFilterInfo] = [DMSFilterInfo]()
    lazy var patientFileData = [AnyObject]()
    override init() {
        super.init()
    }
    
    init(data : [JSON]) {
        super.init()
        for patient in data {
            let pateintFilterListInfo = DMSFilterInfo(patient)
            self.patientFilterList.append(pateintFilterListInfo)
            if let file = patient["patientFileData"].arrayObject {
                self.patientFileData.append(file as AnyObject)
            }
        }
    }
}

