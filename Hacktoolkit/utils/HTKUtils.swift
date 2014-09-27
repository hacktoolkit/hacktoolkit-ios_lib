//
//  HTKUtils.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class HTKUtils {

    class func setDefaults(key: String, withValue value: AnyObject) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
    }

    class func getDefaults(key: String) -> AnyObject? {
        var defaults = NSUserDefaults.standardUserDefaults()
        var value: AnyObject? = defaults.objectForKey(key)
        return value
    }

    class func getStringFromInfoBundleForKey(key: String) -> String {
        var value = NSBundle.mainBundle().objectForInfoDictionaryKey(key) as? String
        return value ?? ""
    }

    class func formatCurrency(amount: Double) -> String {
        var numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        var formattedAmount = numberFormatter.stringFromNumber(amount)
        return formattedAmount
    }

}
