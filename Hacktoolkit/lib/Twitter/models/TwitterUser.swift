//
//  TwitterUser.swift
//
//  Created by Hacktoolkit (@hacktoolkit) and Jonathan Tsai (@jontsai)
//  Copyright (c) 2014 Hacktoolkit. All rights reserved.
//

import Foundation

var _currentTwitterUser: TwitterUser?
let TWITTER_CURRENT_USER_KEY = "kTwitterCurrentUserKey"
let TWITTER_USER_DID_LOGIN_NOTIFICATION = "twitterUserDidLoginNotification"
let TWITTER_USER_DID_LOGOUT_NOTIFICATION = "twitterUserDidLogoutNotification"

class TwitterUser: NSObject {
    var userDictionary: NSDictionary

    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?

    init(userDictionary: NSDictionary) {
        self.userDictionary = userDictionary

        name = userDictionary["name"] as? String
        screenname = userDictionary["screen_name"] as? String
        profileImageUrl = userDictionary["profile_image_url"] as? String
        tagline = userDictionary["description"] as? String
    }

    class var currentUser: TwitterUser? {
        get {
            if _currentTwitterUser == nil {
                var data = HTKUtils.getDefaults(TWITTER_CURRENT_USER_KEY) as? NSData
                if data != nil {
                    var userDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentTwitterUser = TwitterUser(userDictionary: userDictionary)
                }
            }
            return _currentTwitterUser
        }

        set (user) {
            _currentTwitterUser = user
            if _currentTwitterUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.userDictionary, options: nil, error: nil)
                HTKUtils.setDefaults(TWITTER_CURRENT_USER_KEY, withValue: data)
            } else {
                HTKUtils.setDefaults(TWITTER_CURRENT_USER_KEY, withValue: nil)
            }
        }
    }

    func logout() {
        TwitterUser.currentUser = nil
        TwitterClient.sharedInstance.logout()
        NSNotificationCenter.defaultCenter().postNotificationName(TWITTER_USER_DID_LOGOUT_NOTIFICATION, object: nil)
    }
}
