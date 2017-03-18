//
//  URLStruct.swift
//  ICGT Scanner
//
//  Created by Varun Ballari on 2/27/17.
//  Copyright © 2017 Varun Ballari. All rights reserved.
//

import Foundation

struct URLStruct {
    
    struct ICGTurl {
        static let baseURL = "https://tickets.gtindiaclub.com/api/checkin"
    }
    
    struct parameters {
        static let searchMethod = "/search?query="
        static let updateMethod = "/update"
    }
}
