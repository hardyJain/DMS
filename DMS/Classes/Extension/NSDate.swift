//
//  NSDate.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import Foundation


let STANDARD_DATE_FORMAT = "YYYY'-'MM'-'dd HH':'mm':'ss"
let SHORT_DATE_FORMAT = "MMM dd, yyyy, hh:mm:ss a"
let ONLY_DATE_FORMAT = "MMM dd, yyyy"
let STANDARD_ONLY_DATE_FORMAT = "YYYY'-'MM'-'dd"
let MESSAGE_DATE_FORMATE = "dd'-'MMM'-'YYYY"
let BOOKING_DATE_FORMATE = "dd' 'MMMM' 'YYYY"
let TIME = "hh:mm a"
let CHECK_AVALABILITY_FORMATE = "dd'-'MMM'-'YYYY hh:mm a"

extension NSDate {
    
    func getLocalDateStringWithMediumStyle() -> String {
        
        let dateFormatter : DateFormatter = DateFormatter()
//        dateFormatter.timeZone.secondsFromGMT()
        
        let enUSPOSIXLocale : NSLocale = NSLocale.init(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = enUSPOSIXLocale as Locale!
        let theDateFormat = DateFormatter.Style.medium
        let theTimeFormat = DateFormatter.Style.medium
        
        dateFormatter.dateStyle = theDateFormat
        dateFormatter.timeStyle = theTimeFormat
        
        return dateFormatter.string(from: self as Date)
    }
    
    func getLocalDateStringWithFormate(formate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) as Calendar!
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: self as Date)
    }
    
    // Additions
    func addDays(days:Int) -> NSDate? {
        let dayComponent:NSDateComponents = NSDateComponents()
        dayComponent.day = days
        let calendar:NSCalendar = NSCalendar.current as NSCalendar
        return calendar.date(byAdding: dayComponent as DateComponents, to: self as Date, options: NSCalendar.Options.matchStrictly) as NSDate?
    }
    
    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.addingTimeInterval(secondsInHours)
        
        //Return Result
        return dateWithHoursAdded
    }
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool
    {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending
        {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
}

