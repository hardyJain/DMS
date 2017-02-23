//
//  AlertMessages.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import Foundation

class AlertMessages {
    /// Get message string with index
    class func getMessage(at index: Int) -> String {
        switch index {
            // MARK: - App Click
            
        // WS Failure (Due to network)
        case -1001, -1002, -1003, -1004, -1005, -1009:
            return "Oops! Unable to connect to server. Please, check your internet settings and try again."
        default:
            return "Oops! Something went wrong! Please try again or contact customer care."
        }
    }
    
    class func getAlertMessageAtIndex(index: Int) -> String {
        switch index {
        // ***Check Reachability messages.
        case 0 : return "The Internet connection appears to be offline. Please, check the internet settings and try again."
            
        // ***Registration validation messages.
        case 1 : return "Please, Fill all the fields."
        case 2 : return "Please, Enter firstname."
        case 3 : return "Please, Enter lastname."
        case 4 : return "Please, Enter valid email address."
        case 5 : return "Please, Enter password."
        case 6 : return "Please, Enter password (Min. 6 characters and Max. 25 characters)."
        case 7 : return "Please, Enter confirm password."
        case 8 : return "Password does not match!"
        case 9 : return "Please, Enter mobile number."
        case 10 : return "Please, Select country."
        case 11 : return "Please, Select city."
        case 12 : return "Please, Select state."
        case 13 : return "Address not found."
        case 14 : return "User Already Exist."
        case 15 : return "Congratulations, you have successfully registered."
        case 16 : return "Address not found."
        case 17 : return "Please, Enter only character in Firstname."
        case 18 : return "Please, Enter only character in Lastname."
        case 19 : return "Please, Enter Phone number (Min. 10 characters and Max. 15 characters)."
        case 20 : return "Please, Enter Firstname (Max. 15 characters)."
        case 41 : return "Please, Enter Lastname (Max. 15 characters)."
        case 42 : return "Please, Enter Email Address."
        case 43 : return "Please, Select Profile picture."
        case 44 : return "Inactive user."
            
        // *** Login validation messages.
        case 21 : return "Please, Enter email."
        case 22 : return "Please, Enter valid email."
        case 23 : return "Please, Enter password."
        case 24 : return "Failed to login please try again."
        case 25 : return "Invalid Email address or Password."
            
        // *** My Profile validation messages.
        case 31 : return "Please, Enter firstname."
        case 32 : return "Please, Enter lastname."
        case 33 : return "Profile update successfully."
            
        // *** Change Password validation messages.
        case 51 : return "Please, Enter currentPassword."
        case 52 : return "Please, Enter newPassword."
        case 53 : return "Please, Enter confirm your password."
        case 54 : return "Password does not match!"
        case 55 : return "Password change successfully."
        case 56 : return "Invalid current Password."
            
        //
        case 96 : return ""
            
        // *** Filter Search Validation Message.
        case 101 : return "Please, Select location."
        case 102 : return "Please, Enter event type."
        case 103 : return "Please, Enter start date."
        case 104 : return "Please, Enter end date."
        case 105 : return "Please, Enter persons."
        case 106 : return "Please, Check Start date. Start date not greater then the end date."
            
        // *** SendaQuote Validation Message.
        case 111 : return "Please, Enter name."
        case 112 : return "Please, Enter name (Max. 15 characters)"
        case 113 : return "Please, Enter only charecter in name."
        case 114 : return "Please, Enter email address."
        case 115 : return "Please, Enter valid email address."
        case 116 : return "Please, Enter Comments."
        case 117 : return "Please, Enter event type."
        case 118 : return "Please, Enter Budget."
        case 119 : return "Please, Enter start date and time."
        case 120 : return "Please, Enter end date and time."
        case 121 : return "Please, Enter persons."
        case 122 : return "Please, Enter event detail."
            
        // *** Contact Us Validation Message.
        case 131 : return "Please, Enter description."
            
        // *** Location Selection Validation Message.
        case 151 : return "Please, Select country."
        case 152 : return "Please, Select state."
        case 153 : return "Please, Select city."
            
        // *** Write Review Validation Message.
        case 161 : return "Please, Enter review."
        case 162 : return "Please, Rating not empty(Min. 1)."
        case 163 : return "Please, Book venue first to post a review."
            
        // *** Checkavailability Review Validation Message.
        case 171 : return "Please, Enter startdate."
        case 172 : return "Please, Enter enddate."
        case 173 : return "Please, Check Start date. Start date not greater then the end date."
        case 174 : return "Please, Enter persons."
            
        // *** OTP.
        case 191 : return "Please, Enter OTP."
        case 192 : return "Please, Enter Valid OTP."
        // MARK: - Verify OTP
        case 193:
            return "Enter your Mobile Number and we'll send you a confirmation code."
            
        case 201 : return "Invalide mobile number."
        case 202 : return "Invalide mobile number."
            
        // MARK: - ForgotPasswor.
        case 211 : return "Email sent to your registered email id"
            
        // **** Networking operations error messages
        case -1001:
            // Request Time Out.
            return "Operation request time out. Please, try again.";
        case -1002:
            return "";
        case -1003:
            return "A server with the specified hostname could not be found. Please, try again.";
        case -1004:
            // Unable to connect to server.
            return "Unable to connect to server. Please, check the internet settings and try again.";
        //            return @"Unable to connect to server. Please, try again.";
        case -1005:
            // The Internet connection appears to be offline.
            return "The Internet connection appears to be offline. Please, check the internet settings and try again.";
        case -1009:
            // The network connection was lost.
            return "The network connection was lost. Please, check the internet settings and try again.";
            
        case 3840:
            // The operation couldn’t be completed.
            return "The operation couldn’t be completed.";
        default : return ""
            
        }
    }
    
//        class func showAlertWithTitle(title: String, messageIndex: Int, delegate: AnyObject) {
//            let alertView = UIAlertView(title: title, message: AlertMessages.getAlertMessageAtIndex(messageIndex), delegate: delegate, cancelButtonTitle: "Ok")
//            alertView.tag = messageIndex
//            alertView.show()
//        }
    //
    //    class func showAlertWithTitle(title: String,MessageIndex msgIndex: Int,Delegate delegate:UIAlertViewDelegate, CancleButtonTitle cancleTitle: String, Button1Title title1: String,Button2Title title2: String) {
    //
    //        let alertView = UIAlertView(title: title, message: AlertMessages.getAlertMessageAtIndex(msgIndex), delegate: delegate, cancelButtonTitle: cancleTitle, otherButtonTitles: title1, title2)
    //
    //        // Configure Alert View
    //        alertView.tag = msgIndex
    //
    //        // Show Alert View
    //        alertView.show()
    //    }
    //
    //    class func showOkCancleAlertWithTitle(title: String,MessageIndex msgIndex: Int,Delegate delegate:UIAlertViewDelegate, CancleButtonTitle cancleTitle: String, OkButtonTitle okTitle: String) {
    //
    //        let alertView = UIAlertView(title: title, message: AlertMessages.getAlertMessageAtIndex(msgIndex), delegate: delegate, cancelButtonTitle: cancleTitle, otherButtonTitles: okTitle)
    //
    //        // Configure Alert View
    //        alertView.tag = msgIndex
    //        
    //        // Show Alert View
    //        alertView.show()
    //    }
}
