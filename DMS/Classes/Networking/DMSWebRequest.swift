//
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
    case None
    case Basic
    case Bearer
}

enum DMSWebRequestMethodType {
    case GET
    case POST
    case PUT
    case DELETE
}

enum DMSWebRequestFormat {
    case StringFormat
    case JsonFormat
}

class DMSWebRequest: NSObject {
    
    class func Request(Url: NSURL, methodType: DMSWebRequestMethodType = .GET, requestFormat: DMSWebRequestFormat = .JsonFormat, authType: DMSWebRequestAuthorizationType = .None, headers: [String: String]? = nil, params: [String: AnyObject]? = nil, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        var req = URLRequest(url: Url as URL)
        
        switch methodType {
        case .GET:
            req.httpMethod = "GET"
        case .POST:
            req.httpMethod = "POST"
        case .PUT:
            req.httpMethod = "PUT"
        case .DELETE:
            req.httpMethod = "DELETE"
        }
        
        switch requestFormat {
        case .StringFormat:
            req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        case .JsonFormat:
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        switch authType {
        case .None:
            req.setValue("", forHTTPHeaderField: "Authorization")
            break
        case .Basic:
            req.setValue("Basic OTk2NDU4NjM0NzU2NzM0OTg6ZXdyZXJpdXlpd2VydTI=", forHTTPHeaderField: "Authorization")
            break
        case .Bearer:
            let token = Utility.getUserLocalObjectForKey(key: Constants.UserDefault.authAccessToken) as! String
            req.setValue("Bearer" + " " + token, forHTTPHeaderField: "Authorization")
            break
        }
        
        if let _headers = headers {
            for header in _headers {
                req.setValue(header.1, forHTTPHeaderField: header.0)
            }
        }
        
        if methodType != .GET {
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
                if let res = String.init(data: response.data!, encoding: String.Encoding.utf8) {
                    print("Response Result Data : \(res))")
                }
            }
            
            switch response.result {
            case .success:
                if let res = response.result.value {
                    complition(res as AnyObject?)
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
                    if DEBUG_RESPONSE {
                        print("Error: \(error)")
                    }
                    failure(error as NSError?)
                }
            }
        }
    }
    
    class func GET(url: String, authType: DMSWebRequestAuthorizationType = .None, requestFormat: DMSWebRequestFormat = .JsonFormat, headers: [String: String]? = nil,  params: [String: AnyObject]? = nil, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .GET, requestFormat: requestFormat, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
        
      //  DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .GET, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
    }
    
    class func POST(url: String, authType: DMSWebRequestAuthorizationType = .None, requestFormat: DMSWebRequestFormat = .JsonFormat, headers: [String: String]? = nil,  params: [String: AnyObject]? = nil, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .POST, requestFormat: requestFormat, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
        
//        DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .POST, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
        
    }
    
    class func PUT(url: String, authType: DMSWebRequestAuthorizationType = .None, requestFormat: DMSWebRequestFormat = .JsonFormat, headers: [String: String]? = nil,  params: [String: AnyObject]? = nil, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .PUT, requestFormat: requestFormat, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
        
//        DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .PUT, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
    }
    
    class func DELETE(url: String, authType: DMSWebRequestAuthorizationType = .None, requestFormat: DMSWebRequestFormat = .JsonFormat, headers: [String: String]? = nil,  params: [String: AnyObject]? = nil, complition: @escaping (_ result: AnyObject?) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
         DMSWebRequest.Request(Url: NSURL(string: url)!, methodType: .DELETE, requestFormat: requestFormat, authType: authType, headers: headers, params: params, complition: complition, failure: failure)
        
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
