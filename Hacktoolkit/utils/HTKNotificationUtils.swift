//
//  HTKNotificationUtils.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

class HTKNotificationUtils {
    class func displayNetworkErrorMessage() {
        TSMessage.showNotificationWithTitle(
            "Network error",
            subtitle: "Couldn't connect to the server. Check your network connection.",
            type: TSMessageNotificationType.Error
        )
    }
}
