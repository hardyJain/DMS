//
//  Utility.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import Foundation

class Utility {
    static let sharedInstance = Utility()
    
    // NSUserDefault Methods
    class func setUserLocalObject(object: AnyObject?, key: String) -> Bool {
        let defaults = UserDefaults.standard
//        defaults.set(defaults, forKey: key) //setObject(object, forKey: key)
        defaults.set(object, forKey: key)
        return defaults.synchronize()
    }
    
    class func getUserLocalObjectForKey(key: String) -> AnyObject? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key) as AnyObject?
    }
    
    // For String.
    //    class func setStringValueLocally(object: String, key:String) {
    //        let defaults = NSUserDefaults.standardUserDefaults()
    //        defaults.setObject(object, forKey: key)
    //    }
    //
    //    class func getStringValueLocallyWithKey(key:String) -> AnyObject? {
    //        let defaults = NSUserDefaults.standardUserDefaults()
    //        return defaults.objectForKey(key)
    //    }
    //
    //    class func removeStringValueWithKey(key:String){
    //        let defaults = NSUserDefaults.standardUserDefaults()
    //        defaults.removeObjectForKey(key)
    //    }
    
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        
        return result
        
    }
    
    // XXXXX9999X where X is a alphabatic character and 9 is a numeric digit.
    func isValidPANNo(PANNo:String) -> Bool {
        let panRegEx = "[A-Za-z]{5}\\d{4}[A-Za-z]{1}"
        let panTest = NSPredicate(format:"SELF MATCHES %@", panRegEx)
        let result = panTest.evaluate(with: PANNo)
        
        return result
    }
    
    // NSJsonSerialization
    class func jsonObjectFromString(jsonString:String) -> AnyObject? {
        return try! JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!, options: .allowFragments)  as AnyObject?
    }
    
    // Check Rechebility
//    class func isInternetConnectionAvailable() -> Bool {
//        let status = Reach().connectionStatus()
//        switch status {
//        case .Unknown, .Offline:
//            print("Not connected")
//            return false
//        case .Online(.WWAN):
//            //            print("Connected via WWAN")
//            return true
//        case .Online(.WiFi):
//            //            print("Connected via WiFi")
//            return true
//        }
//    }
    
    class func isValidUserName(userName:String) -> Bool {
        for chr in userName.characters {
            if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") && !(chr == " ")) {
                return false
            }
        }
        return true
    }
    
    // NSDate
    class func convertDateStringToDate(date: String!) -> NSDate! {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        let date = dateFormatter.date(from: date!)
        return date as NSDate!
    }
    
    class func convertDateToDateString(date: NSDate) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    
    class func convertDateStringToDate(date: String!, formatter: String!) -> NSDate! {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        let date = dateFormatter.date(from: date)
        return date as NSDate!
    }
    
}
