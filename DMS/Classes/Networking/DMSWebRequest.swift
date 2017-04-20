
//  DMSWebRequest.swift
//  DMS
//
//  Created by Scorg Technologies on 27/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let DEBUG_REQUEST: Bool = true
let DEBUG_RESPONSE: Bool = true

enum DMSWebRequestAuthorizationType {
    case none
    case basic
    case bearer
}

enum DMSWebRequestMethodType {
    case get
    case post
    case put
    case delete
}

enum DMSWebRequestFormat {
    case stringFormat
    case jsonFormat
}

class DMSWebRequest: NSObject {
    
    class func Request(Url: NSURL, methodType: DMSWebRequestMethodType = .get, requestFormat: DMSWebRequestFormat = .jsonFormat, authType: DMSWebRequestAuthorizationType = .none, headers: [String: String]? = nil, params: [String: AnyObject]? = nil, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        var req = URLRequest(url: Url as URL)
        
        switch methodType {
        case .get:
            req.httpMethod = "GET"
        case .post:
            req.httpMethod = "POST"
        case .put:
            req.httpMethod = "PUT"
        case .delete:
            req.httpMethod = "DELETE"
        }
        
        switch requestFormat {
        case .stringFormat:
            req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .jsonFormat:
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        switch authType {
        case .none:
            req.setValue("", forHTTPHeaderField: "Authorization")
            break
        case .basic:
            req.setValue("Basic OTk2NDU4NjM0NzU2NzM0OTg6ZXdyZXJpdXlpd2VydTI=", forHTTPHeaderField: "Authorization")
            break
        case .bearer:
            let token = Utility.getUserLocalObjectForKey(key: Constants.UserDefault.authAccessToken) as! String
            req.setValue("Bearer" + " " + token, forHTTPHeaderField: "Authorization")
            break
        }
        
        if let _headers = headers {
            for header in _headers {
                req.setValue(header.1, forHTTPHeaderField: header.0)
            }
        }
        
        if methodType != .get {
            if let p = params {
                req.httpBody = try! JSONSerialization.data(withJSONObject: p, options: [])
            }
        }
        // Append params to query string incomplete
        //        else {
        //            if let p = params {
        //                req.URL?.query =
        //            }
        //        }
        
        if DEBUG_REQUEST {
            print("Request Headers : \(req.allHTTPHeaderFields)")  // original URL request
            if let p = params {
                print("Request Params : \(JSON(p))\n")
            }
        }
        
        request(req).responseJSON { response in
            if DEBUG_RESPONSE {
                print("Response Headers : \(response.response)") // URL response
                
                print("Response Result : \(response.result)")   // result of response serialization (Success/Failure)
                
                //print("Response Data : \(response.data)")     // server data
                if let _ = String.init(data: response.data!, encoding: String.Encoding.utf8) {
//                    print("Response Result Data : \(res))")
                }
            }
            
            switch response.result {
            case .success:
                if let res = response.result.value {
                    
                    if response.response?.statusCode == 401 {
                        
                        let json = JSON(response.result.value as Any)
                        if let res = json["Message"].string, res == "Authorization has been denied for this request." {
                            
                            DMSWebRequest.GetAuthToken(Url: Url, methodType: methodType, requestFormat: requestFormat, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
                        }
                    } else {
                    
                        complition(res as AnyObject?)
                    }
                }
            case .failure(let error):
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    if let res = response.result.value {
                        complition(res as AnyObject?)
                    }
                    else {
                        complition([] as AnyObject?)
                    }
                }
                else {
                    
                    if response.response?.statusCode == 401 {
                    
                        let json = JSON(response.result.value as Any)
                        if let res = json["Message"].string, res == "Authorization has been denied for this request." {
                        
                            DMSWebRequest.GetAuthToken(Url: Url, methodType: methodType, requestFormat: requestFormat, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
                        }
                    }
                    if DEBUG_RESPONSE {
                        print("Error: \(error)")
                    }
                    failure(error as NSError?)
                }
            }
        }
    }
    
    class func GetAuthToken(Url: NSURL, methodType: DMSWebRequestMethodType = .get, requestFormat: DMSWebRequestFormat = .jsonFormat, authType: DMSWebRequestAuthorizationType = .none, headers: [String: String]? = nil, params: [String: AnyObject]? = nil, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
    
        var httpHeaders: HTTPHeaders = Globals().getRequestHeaderParams()
        httpHeaders["Content-Type"] = "application/x-www-form-urlencoded"
        
        guard let refresh_token = Utility.getUserLocalObjectForKey(key: Constants.UserDefault.authRefereshToken) as? String else {
            
            (UIApplication.shared.delegate as! AppDelegate).initLoginScreen()
            return
        }
        
        let para: Parameters = [
            "grant_type": "refresh_token",
            "refresh_token": refresh_token,
            "client_id": Constants.clientId
        ]
        
        Alamofire.request(Constants.ApiUrls.access_token, method: .post, parameters: para, encoding: URLEncoding.default, headers: httpHeaders).responseJSON { (response) in
            
//            Utility.getUserLocalObjectForKey(key: Constants.UserDefault.authAccessToken

            if response.result.isFailure {
            
                let json = JSON(response.result.value as Any)
                if (json["error"].string ?? "") == "invalid_grant" {
                
                    (UIApplication.shared.delegate as! AppDelegate).initLoginScreen()
                }
                
            } else {
                
                let json = JSON(response.result.value as Any)
                if (json["error"].string ?? "") == "invalid_grant" {
                    
                    (UIApplication.shared.delegate as! AppDelegate).initLoginScreen()
                    
                    return
                }
            
                if let accessToken = json["access_token"].string {
                    if Utility.setUserLocalObject(object: accessToken as AnyObject?, key: Constants.UserDefault.authAccessToken) {
                    }
                }
                if let refereshToken = json["refresh_token"].string {
                    if Utility.setUserLocalObject(object: refereshToken as AnyObject?, key: Constants.UserDefault.authRefereshToken) {
                    }
                }
                
                DMSWebRequest.Request(Url: Url, methodType: methodType, requestFormat: requestFormat, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
                
            }
        
        }
        
    }
    
    class func GET(url: String, authType: DMSWebRequestAuthorizationType = .none, requestFormat: DMSWebRequestFormat = .jsonFormat, headers: [String: String]? = nil,  params: [String: AnyObject]? = nil, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .get, requestFormat: requestFormat, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
        
      //  DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .GET, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
    }
    
    class func POST(url: String, authType: DMSWebRequestAuthorizationType = .none, requestFormat: DMSWebRequestFormat = .jsonFormat, headers: [String: String]? = nil,  params: [String: AnyObject]? = nil, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .post, requestFormat: requestFormat, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
        
//        DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .POST, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
        
    }
    
    class func PUT(url: String, authType: DMSWebRequestAuthorizationType = .none, requestFormat: DMSWebRequestFormat = .jsonFormat, headers: [String: String]? = nil,  params: [String: AnyObject]? = nil, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .put, requestFormat: requestFormat, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
        
//        DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .PUT, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
    }
    
    class func DELETE(url: String, authType: DMSWebRequestAuthorizationType = .none, requestFormat: DMSWebRequestFormat = .jsonFormat, headers: [String: String]? = nil,  params: [String: AnyObject]? = nil, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
         DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .delete, requestFormat: requestFormat, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
        
//        DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .DELETE, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
    }
    
    class func POSTSTRING(requestString: String, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        var request = URLRequest(url: URL(string: Constants.ApiUrls.login)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("", forHTTPHeaderField: "Authorization")
        var headers: [String: String]? = nil
        headers = ["Device-Id": Constants.deviceId, "OS": "iOS", "OS-Version": Constants.OSVersion]
        if let _headers = headers {
            for header in _headers {
                request.setValue(header.1, forHTTPHeaderField: header.0)
            }
        }
        let postString = requestString
        request.httpBody = postString.data(using: .utf8)
        print("Request String - \(request)")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(error)")
                failure(error as? NSError)
                return 
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: String.Encoding.utf8)
            print("responseString = \(responseString)")
            if let data = responseString?.data(using: .utf8) {
                do {
                    complition( try JSONSerialization.jsonObject(with: data, options: []) as AnyObject?)
                } catch {
                    print(error.localizedDescription)
                }
            }
            failure(error as NSError?)
        }
        task.resume()
    }
}
