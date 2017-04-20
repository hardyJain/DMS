//
//  DMSTag.swift
//  DMS
//
//  Created by Scorg Technologies on 21/02/17.
//  Copyright © 2017 Scorg Technologies. All rights reserved.
//

import UIKit

struct Tag {
    
    struct Login {
        static let email = 0
        static let password = 1
    }
    
    struct Filter {
        static let iDType = 0
        static let idNumber = 1
        static let docType = 2
        static let dateFrom = 3
        static let dateTo = 4
        static let patientName = 5
        static let annotation = 6
        static let annotationSelect = 7
    }
    
    struct FilterPicker {
        static let idType = 0
        static let docType = 1
    }
}
