//
//  String.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func setFirstCharecterFontWithFontName(fontName: String, size: CGFloat, fontColor: UIColor) -> NSMutableAttributedString {
        
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!])
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: fontColor, range: NSRange(location:0,length:self.characters.count))
        
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: fontName,size: size)!, range: NSRange(location:0, length:1))
        return myMutableString
    }
    
    func setColorWithLocation(startLocation: Int, length: Int, fontColor: UIColor) -> NSMutableAttributedString {
        
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!])
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: fontColor, range: NSRange(location:startLocation,length:length))
        
        return myMutableString
    }
    
    func setTwoColorStringWithLocation(firstStartLocation: Int, firstLength: Int,secondStartLocation: Int, secondLength: Int, fontColor: UIColor) -> NSMutableAttributedString {
        
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!])
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: fontColor, range: NSRange(location:firstStartLocation,length:firstLength))
        
        let myMutableString2 = myMutableString
        
        myMutableString2.addAttribute(NSForegroundColorAttributeName, value: fontColor, range: NSRange(location:secondStartLocation,length:secondLength))
        
        return myMutableString2
    }
    
    func setFirstCharecterFontWithFontName(fontName: String, size: CGFloat, firstCharacterColor: UIColor) -> NSMutableAttributedString {
        
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!])
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: firstCharacterColor, range: NSRange(location:0,length:1))
        
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: fontName,size: size)!, range: NSRange(location:0, length:1))
        return myMutableString
    }
    
    func setCharecterFontWithFontName(fontName: String, size: CGFloat, firstCharacterColor: UIColor, range: NSRange) -> NSMutableAttributedString {
        
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: self, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 15.0)!])
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: firstCharacterColor, range: range)
        
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont(
                                        name: fontName,
                                        size: size)!,
                                     range: range)
        return myMutableString
    }
    
}
