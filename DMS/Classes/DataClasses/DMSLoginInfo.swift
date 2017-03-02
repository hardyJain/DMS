//
//  DMSLoginInfo.swift
//  DMS
//
//  Created by Scorg Technologies on 27/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import SwiftyJSON

private let loginEmailKey = "username"
private let loginPasswordKey = "password"
private let loginGrantTypeKey = "grant_type"
private let loginClientIdKey = "client_id"

class DMSLoginInfo: NSObject {
    
    lazy var grantType = "password"
    lazy var email = String()
    lazy var password = String()
    lazy var clientId = Constants.clientId
    
    override init() {
        super.init()
    }
    
    init(_ result: AnyObject) {
        super.init()
        
//        let dataDict = JSON(result)
//        
//        if let val = dataDict[loginEmailKey].string {
//            email = val
//        }
//        if let val = dataDict[loginPasswordKey].string {
//            password = val
//        }
    }
    
    func getDataDictionaryForWS() -> Dictionary<String, String> {
        var loginParams = Dictionary<String,String>()
        loginParams[loginPasswordKey] = password
        loginParams[loginEmailKey] = email
        loginParams[loginGrantTypeKey] = grantType
        loginParams[loginClientIdKey] = Constants.clientId
        
        return loginParams
    }
    
    func getDataStringForEncodedRequest() -> String {
        var loginString = String()
        loginString = "\(loginGrantTypeKey)=\(grantType)&\(loginClientIdKey)=\(clientId)&\(loginEmailKey)=\(email)&\(loginPasswordKey)=\(password)"
        return loginString
    }
}
