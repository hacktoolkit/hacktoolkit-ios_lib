//
//  YelpCategory.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class YelpCategory {
    var categoryName: String!
    var categoryKey: String!

    init(categoryArray: NSArray) {
        self.categoryName = categoryArray[0] as? String
        self.categoryKey = categoryArray[1] as? String
    }
}
