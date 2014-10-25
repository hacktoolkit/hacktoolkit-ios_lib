//
//  GitHubClient.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

let GITHUB_API_CONSUMER_KEY = HTKUtils.getStringFromInfoBundleForKey("GITHUB_API_CONSUMER_KEY")
let GITHUB_API_CONSUMER_SECRET = HTKUtils.getStringFromInfoBundleForKey("GITHUB_API_CONSUMER_SECRET")

let GITHUB_API_BASE_URL = "https://api.github.com"

class GitHubClient {

    var cache = [String:AnyObject]()

    class var sharedInstance : GitHubClient {
        struct Static {
            static var token : dispatch_once_t = 0
            static var instance : GitHubClient? = nil
        }
        dispatch_once(&Static.token) {
            Static.instance = GitHubClient()
        }
        return Static.instance!
    }

    func makeApiRequest(resource: String, callback: (AnyObject) -> ()) {
        var apiUrl = "\(GITHUB_API_BASE_URL)\(resource)"
        // temporarily include App key to increase rate limit
        // https://developer.github.com/v3/#increasing-the-unauthenticated-rate-limit-for-oauth-applications
        apiUrl = "\(apiUrl)?client_id=\(GITHUB_API_CONSUMER_KEY)&client_secret=\(GITHUB_API_CONSUMER_SECRET)"
        let request = NSMutableURLRequest(URL: NSURL(string: apiUrl)!)
        NSLog("Hitting API: \(apiUrl)")

        var cachedResult: AnyObject? = cache[apiUrl]
        if cachedResult != nil {
            callback(cachedResult!)
        } else {
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) in
                var errorValue: NSError? = nil
                let result: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue)
                if result != nil {
                    callback(result!)
                    self.cache[apiUrl] = result!
                } else {
                    HTKNotificationUtils.displayNetworkErrorMessage()
                }
            })
        }
    }
}
