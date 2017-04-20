//
//  TreeViewData.swift
//  DMS
//
//  Created by Swapnil Dhotre on 23/03/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import Foundation

class TreeViewData {
    var level: Int
    var name: String
    var id: String
    var parentId: String
    
    init?(level: Int, name: String, id: String, parentId: String) {
        self.level = level
        self.name = name
        self.id = id
        self.parentId = parentId
    }
}

