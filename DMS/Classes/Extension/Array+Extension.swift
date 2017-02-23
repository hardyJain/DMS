//
//  Array+Extension.swift
//  DMS
//
//  Created by Scorg Technologies on 20/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    mutating func removeObject(object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object: object)
        }
    }
}
